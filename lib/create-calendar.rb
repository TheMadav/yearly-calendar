require 'rubygems'
require 'csv'
require 'pp'
require "Date"
require 'icalendar'
require 'net/http'
require 'yaml'

def import_ics_file file
     cal_file = File.open(file)
     # Parser returns an array of calendars because a single file
     # can have multiple calendars.
     cals = Icalendar::Calendar.parse(cal_file)
     return cals.first
end

def import_ics_file_from_server url
    uri = URI(url)
    calendar = Net::HTTP.get(uri)
    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar::Calendar.parse(calendar)
    return cals.first
end

def write_events_file events, source, name
    eventList = Array.new
    events.each do |event|        
        if source.has_key? "period"
            eventList << "\\holidays{A}{#{event[:date]}}{#{event[:enddate]}}"
            #eventList << "\\period{#{event[:date]}}{#{event[:enddate]}}[name=#{event[:description]}, color=#{event[:color]}]"
        else
            eventList << "\\event*{#{event[:date]}}{#{event[:description]}}[color=#{event[:color]}]"
        end
    end
    File.open("./events/#{name}.events", 'w') { |file| file.write(eventList.join("\n")) }
    return eventList
end

def import_ical_file source 
    if source.has_key? CONFIG_FILE
        cals = import_ics_file_local source[CONFIG_FILE]
    elsif source.has_key? CONFIG_URL
        cals = import_ics_file_from_server source[CONFIG_URL]
    end
    
    dates = Array.new
    cals.events.each do |event|
        enddate = [event.dtend.to_date, Date.new(Time.now.year+1, 12, 31)].min
        dates << {
                :date           => event.dtstart , 
                :enddate        => source['period'].nil? ? nil : enddate,
                :description    => source['icon'].nil? ? event.summary : "\\#{source['icon']} ~ #{event.summary}", 
                :color          => source['color']

        }
    end
    return dates

end

def import_local_csv source 
    csvImport = CSV.read(source['file'],  :headers => %i[date name icon]) 
    dates = Array.new
    csvImport.each do |event|
        date = Date.parse(event[:date])
        difference = Time.new.year+1 -date.year

        # Build the description from icon, name and difference (if wanted)
        description = event.has_key?(:icon) ? "\\#{event[:icon]} ~" : ""
        description = description + event[:name]
                
        if source['calcDifference'] 
            # Calculates the correct year for the birthday list    
            difference < 0 ? age = "" : description = description + "(#{difference})"
        end
        dates << {
                :date           => date.next_year(difference) , 
                :description    => description, 
                :color          => source['color']
            }
    end
    return dates
end

# MAGIC VALUES
CSV_FILE    = ".csv"
ICS_File    = ".ics"
CONFIG_URL  = "url"
CONFIG_FILE = "file"

puts "Loading configuration..."
file = File.open("./config.yaml")
config = YAML.load(file) 


puts "#{config.count} sources for events"

config.each do |source|
    name = source.first[0]
    puts "Starting with #{name}"
    
    if source[name].has_key? CONFIG_URL
        puts "Loading events from server"
        events = import_ical_file source[name]
    
    elsif source[name].has_key? CONFIG_FILE
        unless File.exist?(source[name]['file'])
            puts "ERROR: File does not exist, continue with next source"
            next
        end
        puts "Loading events from file"
        if File.extname(source[name][CONFIG_FILE]) == CSV_FILE
            events = import_local_csv source[name]
        elsif File.extname(source[name][CONFIG_FILE]) == ICS_File
            events = import_ical_file source[name]
        end        
    end
    
    puts "Writing events file"
    write_events_file events, source[name], name
    puts "=================="
end