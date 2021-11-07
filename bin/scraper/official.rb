#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      tds.first.text.tidy.split(', ').reverse.join(' ').delete_prefix('Dr. ')
    end

    def position
      tds[1].text.split(/ and (?=Minister(?! of Legal))/)
        .flat_map { |posn| posn.split(/ and (?=Leader)/) }
        .flat_map(&:tidy)
    end

    private

    def tds
      noko.css('td')
    end
  end

  class Members
    def member_container
      noko.css('.detailTable').xpath('.//tr[td]').drop(1)
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
