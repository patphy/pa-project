#!/usr/bin/env ruby
# encoding: UTF-8

require 'lib/connect_mysql'

mysql = Connect_mysql.new('chuya', '0514')

#input db
mypaper = mysql.db('mypaper')
#output db
patentproject = mysql.db('patentproject2012')

patent_2009 = mypaper.query("select Patent_id, Assignee from `content_2009` limit 0,1000 ")

p_more_assignee = []
max_assignee = 0
patent_2009.each do |p|
  patent_id = p['Patent_id']
  if p['Assignee'].nil?
    assignee = nil
    location = nil
    #puts "id:#{patent_id}||   without assignee"
  else
    assignee_str = p['Assignee'].strip().split(/([A-Z]{2}\)|\([A-Z]{2}\)|\s*unknown\))/)
    #    location_index = assignee_str.index(/\(([a-zA-Z]|\s)*,\s[A-Z]*\)/)
    #    result = /(\s*[A-Z]{2}\)|\([A-Z]{2}\))/.match(assignee_str)
    if assignee_str.count.even? and assignee_str.count/2 > 1
      puts "\npatent_id = #{patent_id}"
      puts "    |result = #{assignee_str.count}"
      puts "          |origin = #{p['Assignee'].strip()}"
      puts "              |str = #{assignee_str}"

      assignee_str.each do |str|
        if assignee_str.index(str).even?
          next_str = assignee_str[assignee_str.index(str)+1]
          if next_str.match(/\([A-Z]{2}\)/)
            assignee = str
            location = next_str
            puts "                  |assignee = #{assignee}"
            puts "                      |location = #{location}"

          else
            re_str = str.reverse
            puts "                  |re_str = #{re_str}"
            re_str_split = re_str.split(/\(\s{1}/)
            puts "                  |re_str_split = #{re_str_split}"
            assignee = re_str_split[1].reverse
            location = re_str_split[0].reverse + next_str
            puts "                  |assignee = #{assignee}"
            puts "                      |location = #{location}"
          end
        end
      end

    else

    end

  end

  #  patentproject.query("INSERT INTO assignee (Patent_id, Assignee, Location)
  #                       VALUES ('#{patent_id}', '#{assignee}', '#{location}')    " )
end