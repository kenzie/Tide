
require 'helper'

class TideTest < Test::Unit::TestCase

  # TODO fake web requests

  def test_location
    @tide = Tide.new(:station => 9)
    assert_match "Garnet Point", @tide.location
  end

  def test_to_csv
    @tide = Tide.new
    date_regex = /\d{4}-\d{2}-\d{2}/
    assert_match date_regex, @tide.to_csv
  end

  def test_to_html
    @tide = Tide.new
    date_regex = /<tr><th scope=\"rowgroup\" colspan=\"2\">\d{4}-\d{2}-\d{2}<\/th><\/tr>/
    assert_match date_regex, @tide.to_html
  end

  def test_specific_date
    a_year_ago = Time.now - 60*60*24*365
    @tide = Tide.new(:date => a_year_ago)
    formatted_date = a_year_ago.strftime('%Y-%m-%d')
    date_regex = /<tr><th scope=\"rowgroup\" colspan=\"2\">#{formatted_date}<\/th><\/tr>/
    assert_match date_regex, @tide.to_html
  end

  def test_specific_timezone
    tide_ast = Tide.new(:timezone => 'AST')
    tide_est = Tide.new(:timezone => 'EST')
    assert_not_equal tide_ast.to_csv, tide_est.to_csv
  end

end
