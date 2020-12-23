require 'rubygems'
require 'CSV'
require 'pp'
require "Date"
require 'icalendar'

BIRTHDAY_CSV = "./data/01_birthdays.csv"
# Download from Hebcal
HEBCAL = "./data/hebcal_2021.ics"
# Download from Schulferien.org https://www.schulferien.org/deutschland/ical/
HOLIDAYS = './data/feiertage_hessen_2021.ics'
VACATIONS ="./data/Hessen_2021_Schulferien.ics"

JEWISH_HOLIDAY_COLOR    = "Blue!20"
BIRTHDAY_COLOR          = "Red!20"
CHRISTIAN_HOLIDAY_COLOR = "Black!20"
VACATION_COLOR             ="Black!10"

def read_birthday_csv 
    csvImport = CSV.read(BIRTHDAY_CSV,  :headers => %i[date name icon]) 
    dates = Array.new
    csvImport.each do |event|
        birthday = Date.parse(event[:date])
        # Calculates the correct year for the birthday list
        difference = Time.new.year+1 -birthday.year
        dates << {:date => birthday.next_year(difference) , :description => "\\#{event[:icon]} ~ #{event[:name]} (#{difference})", :color=>BIRTHDAY_COLOR}
    end
    return dates
end

def import_ics_files file
     # Open a file or pass a string to the parser
     cal_file = File.open(file)
     # Parser returns an array of calendars because a single file
     # can have multiple calendars.
     cals = Icalendar::Calendar.parse(cal_file)
     return cals.first
end

def import_jewish_holidays 
    cals = import_ics_files HEBCAL
    dates = Array.new
    cals.events.each do |event|
        dates << {:date => event.dtstart , :description => "\\faStarOfDavid ~ #{event.summary}", :color=>JEWISH_HOLIDAY_COLOR}
    end
    return dates
end

def import_vacation_dates
    cals = import_ics_files VACATIONS
    dates = Array.new
    cals.events.each do |event|
        dates << {:date => event.dtstart , :enddate => event.dtend, :description => "", :color=>VACATION_COLOR}
    end
    return dates
end

def import_holidays 
    cals = import_ics_files HOLIDAYS
    dates = Array.new
    cals.events.each do |event|
        dates << {:date => event.dtstart , :description => event.summary, :color=>CHRISTIAN_HOLIDAY_COLOR}
    end
    return dates
end

def write_events_file events, file
    eventList = Array.new
    events.each do |event|        
        unless event[:enddate].nil?
            eventList << "\\period{#{event[:date]}}{#{event[:enddate]}}[name=#{event[:description]}, color=#{event[:color]}]"
        else
            eventList << "\\event*{#{event[:date]}}{#{event[:description]}}[color=#{event[:color]}]"
        end
    end
    File.open("./events/#{file}.events", 'w') { |file| file.write(eventList.join("\n")) }
    return eventList

end

write_events_file(read_birthday_csv, "Geburtstage")
write_events_file(import_jewish_holidays, "JewishHolidays")
write_events_file(import_holidays, "GesetzlicheFeiertage")
write_events_file(import_vacation_dates, "Ferien")
