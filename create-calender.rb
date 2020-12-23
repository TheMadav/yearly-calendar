require 'rubygems'
require 'CSV'
require 'pp'
require "Date"
require 'icalendar'

BIRTHDAY_CSV = "./data/01_birthdays.csv"
# Download from Hebcal
HEBCAL_CSV = "./data/hebcal_2021_eur.csv"
# Download from Schulferien.org https://www.schulferien.org/deutschland/ical/
#HESSEN_CSV = "./data/hessen.csv"
HOLIDAYS = './data/feiertage_hessen_2021.ics'
VACATION_ICAL ="./data/Hessen_2021_Schulferien.ics"

JEWISH_COLOR    = "Blue!20"
BIRTHDAY_COLOR  = "Red!20"
HOLIDAY_COLOR = "Black!20"
VACATION_COLOR  ="Black!10"

def read_birthday_csv 
    csvImport = CSV.read(BIRTHDAY_CSV,  :headers => %i[date name icon]) 
    dates = Array.new
    csvImport.each do |birthday|
        dates << {:date => Date.parse(birthday[:date]) , :description => "#{birthday[:name]}", :color=>BIRTHDAY_COLOR}
    end
    return dates
end

def read_hebcal_csv 
    csvImport = CSV.read(HEBCAL_CSV, :headers=>true) 
    dates = Array.new
    csvImport.each do |row|
        dates << {:date => Date.parse(row["Start Date"]) , :description => row["Subject"], :color=>JEWISH_COLOR}
    end
    return dates
end

def read_vacation_hessen_ical
    # Open a file or pass a string to the parser
    cal_file = File.open(VACATION_ICAL)
    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar::Calendar.parse(cal_file)
    dates = Array.new
    cals.first.events.each do |event|
        dates << {:date => event.dtstart , :enddate => event.dtend, :description => event.summary.split(" ").first, :color=>VACATION_COLOR}
    end
    return dates
end

def read_hessen_csv 
    # Open a file or pass a string to the parser
    cal_file = File.open(HOLIDAYS)
    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar::Calendar.parse(cal_file)
    dates = Array.new
    cals.first.events.each do |event|
        dates << {:date => event.dtstart , :description => event.summary, :color=>HOLIDAY_COLOR}
    end
    return dates
end

def write_events_file events, file
    eventList = Array.new
    events.each do |event|
        difference = Time.new.year+1 - event[:date].year
        event[:date] = event[:date].next_year(difference)
        
        unless event[:enddate].nil?
            event[:enddate] = event[:enddate].next_year(difference)
            #\event{\year-03-14}{Albert = Einstein (1879)}
            eventList << "\\period{#{event[:date]}}{#{event[:enddate]}}[name=#{event[:description]}, color=#{event[:color]}]"
        else
            #\event{\year-03-14}{Albert = Einstein (1879)}
            eventList << "\\event*{#{event[:date]}}{#{event[:description]}}[color=#{event[:color]}]"
        end
    end
    File.open("./events/#{file}.events", 'w') { |file| file.write(eventList.join("\n")) }
    return eventList

end
read_vacation_hessen_ical
write_events_file(read_birthday_csv, "Geburtstage")

#write_events_file(read_hebcal_csv, "JewishHolidays")
write_events_file(read_hessen_csv, "GesetzlicheFeiertage")
write_events_file(read_vacation_hessen_ical, "Ferien")
exit

#puts calender_template
#calender_template = replace_in_template calender_template, birthdays, "birthdays"
#calender_template = replace_in_template calender_template, jewish_holidays, "jewish_holidays"
timestamp = Time.now.strftime "%Y-%m-%d-%H-%M" 
File.open("./output/#{timestamp}-calender.tex", 'w') { |file| file.write(calender_template) }
