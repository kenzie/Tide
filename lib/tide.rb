
require 'net/http'
require 'uri'

class Tide

  POST_URL      = 'http://www.waterlevels.gc.ca/cgi-bin/tide-shc.cgi'
  TIDE_REGEX    = /#\sDate;Time;Height<br>(.*)<br><\/p><\/td>/
  STATION_REGEX = /#\sStation\s:\s(.*)\s\(\d+\).*/

  # Create new tide table.
  def initialize(options = {})
    options     = { :station => 610, :timezone => 'AST', :date => Time.now }.merge(options)
    @station    = options[:station]
    @timezone   = options[:timezone]
    @date       = options[:date]
  end

  # Shortcut for station lookup
  def self.station(sid)
    new(:station => sid)
  end

  # Download raw data
  def data
    @data ||= download_tide_data
  end

  # Returns semi-colon delimited list of tide data.
  def to_csv
    @csv ||= format_csv
  end

  # Returns formatted html table of tide data.
  def to_html
    @html ||= format_html
  end

private

  # Downloads new tide data
  def download_tide_data(type='predict', view='text', language='english')
    res = Net::HTTP.post_form(
    URI.parse(POST_URL),
      {
        'station'   => @station,
        'year'      => @date.year,
        'month'     => @date.month,
        'day'       => @date.day,
        'TZ'        => @timezone, # TODO use supplied date for timezone
        'queryType' => type,
        'view'      => view,
        'language'  => language
      }
    )
    # TODO rescue request errors
    res.body
  end

  # Formats tide data as csv.
  def format_csv
    data.match(TIDE_REGEX)[1].gsub('<br>', "\n").gsub(';', ',')
  end

  # Formats tide data as html table.
  def format_html
    formatted = "<table summary=\"Tide tables with columns for time of day and tide height (in meters).\">\n\t<thead>\n\t\t<tr><th scope=\"col\">Time</th><th scope=\"col\">Height</th></tr>\n\t</thead>\n"
    last_date = nil
    to_csv.each_line do |row|
      row = row.chomp.split(',')
      if row[0] != last_date
        formatted += "\t</tbody>\n" unless last_date.nil?
        formatted += "\t<tbody>\n\t\t<tr><th scope=\"rowgroup\" colspan=\"2\">#{row[0]}</th></tr>\n"
        last_date = row[0]
      end
      formatted += "\t\t<tr><td>#{row[1]}</td><td>#{row[2]}m</td></tr>\n"
    end
    formatted += "\t</tbody>\n</table>\n"
    formatted
  end

end