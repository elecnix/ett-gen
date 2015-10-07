#!/usr/bin/env ruby
require "prawn"

Prawn::Document.generate("ett.pdf") {
  dash(3, :space => 2)
  stroke_color "aaaaaa"
  self.line_width = 0.5
  font "Helvetica", :style => :bold
  text "THE EMERGENT TASK TIMER"
  header_top = cursor
  header_height = 20
  row_height = 20
  column_width = 50
  column_count = 4
  font "Helvetica"
 
  def column(options)
    fill_color "EEEEEE"
    fill_rectangle [options[:left], options[:top]], options[:column_width], options[:rows] * options[:row_height]
    0.upto(options[:rows] - 1).each { |row|
      row_top = options[:top] - options[:row_height] * row
      fill_color "FFFFFF"
      bubble_vmargin = options[:row_height] * 0.2
      bubble_width = (options[:column_width] / 9)
      bubble_height = options[:row_height] * 0.8
      undash
      stroke_color "333333"
      0.upto(3).each { |bubble|
        bubble_left = options[:left] + bubble_width + bubble * bubble_width * 2
        1.upto(2).each { |sub|
          horizontal_line(
            bubble_left,
            bubble_left + bubble_width,
            :at => row_top - bubble_vmargin - sub * bubble_height / 3)
        }
        fill_and_stroke_rounded_rectangle(
          [bubble_left, row_top - bubble_vmargin],
          bubble_width,
          bubble_height,
          bubble_width / 2)
      }
    }
  end

  fill_color "CCCCCC"
  page_width = 550
  row_count = 15
  fill_rectangle [0, header_top], page_width, header_height
  fill_color "000000"
  draw_text "TASKS", :at => [5, header_top - header_height + 5] 
  draw_text "START TIME", :at => [200, header_top - header_height + 5] 
  draw_text "DATE", :at => [370, header_top - header_height + 5] 
  fill_color "FFFFFF"
  fill_rectangle [275, header_top - 2.5], 50, 20 - 5
  fill_rectangle [430, header_top - 2.5], 50, 20 - 5
  0.upto(column_count - 1).each { |col|
    column(
      :top => header_top - header_height,
      :left => 275 + col * (column_width + 5),
      :rows => row_count,
      :row_height => row_height,
      :column_width => column_width)
  }
# TODO make this work:
  0.upto(row_count).each { |row|
    horizontal_line(
      0,
      page_width,
      :at => header_top - row_height * row)
  }
}

