#!/usr/bin/env ruby
require "prawn"
require "prawn/measurement_extensions"

Prawn::Document.generate("ett.pdf") {
  page_width = 550
  page_height = 625
  header_height = 18
  row_height = 25
  task_width = 300
  total_line_width = 25
  column_count = 9
  column_width = (page_width - task_width - total_line_width) / column_count
  row_count = 14

  note_count = 14

  # Title
  stroke_color "aaaaaa"
  self.line_width = 0.5
  font "Helvetica", :style => :bold
  font_size 12
  text "THE EMERGENT TASK TIMER"
  header_top = cursor
  font "Helvetica"
  font_size 10

  def bucket(bucket_top, bucket_hcenter, bucket_width, bucket_height)
    stroke_color "AAAAAA"
    [-1,1].each { |edge|
      stroke_vertical_line(
        bucket_top,
        bucket_top - bucket_height,
        :at => bucket_hcenter + bucket_width / 2 * edge)
    }
    stroke_horizontal_line(
      bucket_hcenter - bucket_width / 2,
      bucket_hcenter + bucket_width / 2,
      :at => bucket_top - bucket_height)
  end
 
  def column(options)
    column_top = options[:top]
    column_left = options[:left]
    row_height = options[:row_height]

    # Column shade
    fill_color(options[:odd] ? "DDDDDD" : "FFFFFF")
    fill_rectangle(
        [options[:left], options[:bleed_top]],
        options[:column_width],
        options[:rows] * options[:row_height] - options[:top] + options[:bleed_top])

    # Left Bucket
    bucket(column_top, column_left, 15, 3)

    # Row bubbles
    0.upto(options[:rows] - 1).each { |row|
      row_top = options[:top] - options[:row_height] * row

      # Left of line
      stroke_color "CCCCCC"
      stroke_vertical_line(
        row_top - row_height * 0.3,
        row_top - options[:row_height],
        :at => 0)

      # Bubbles
      fill_color "FFFFFF"
      slice_width = options[:column_width].to_f / 4
      bubble_hmargin = slice_width.to_f * 0.25
      bubble_width = slice_width - bubble_hmargin * 2
      bubble_vmargin = options[:row_height].to_f * 0.3
      bubble_height = options[:row_height].to_f * 0.5
      undash
      stroke_color "333333"
      0.upto(3).each { |bubble|
        bubble_left = options[:left] + slice_width * bubble + bubble_hmargin
        1.upto(2).each { |sub|
          horizontal_line(
            bubble_left,
            bubble_left + bubble_width,
            :at => row_top - bubble_vmargin - sub * bubble_height / 3)
        }
        stroke_color "666666"
        fill_and_stroke_rounded_rectangle(
          [bubble_left, row_top - bubble_vmargin],
          bubble_width,
          bubble_height,
          bubble_width / 2)
      }
    }
  end

  # Task columns
  column_top = header_top - header_height * 1.5
  0.upto(column_count - 1).each { |col|
    column(
      :odd => col % 2 == 0,
      :top => column_top,
      :bleed_top => header_top - header_height,
      :left => task_width + col * column_width,
      :rows => row_count,
      :row_height => row_height,
      :column_width => column_width)
  }
  # last bucket
  bucket(column_top, task_width + column_count * column_width, 15, 3)

  # Header
  fill_color "CCCCCC"
  fill_rectangle [0, header_top], page_width, header_height
  fill_color "000000"
  draw_text "TASKS", :at => [5, header_top - header_height + 5], :valign => :center
  draw_text "START TIME", :at => [212, header_top - header_height + 5], :valign => :center
  draw_text "DATE", :at => [395, header_top - header_height + 5], :valign => :center
  fill_color "FFFFFF"
  header_form_height = header_height * 0.8
  header_form_top = header_top - (header_height - header_form_height) / 2
  fill_rectangle [task_width - column_width, header_form_top], column_width * 2, header_form_height
  fill_rectangle [task_width + column_width * (column_count - 4), header_form_top], column_width * 4, header_form_height

  1.upto(row_count).each { |row|

    # Task line
    stroke_color "CCCCCC"
    stroke_horizontal_line(
      0,
      page_width - total_line_width,
      :at => column_top - row_height * row)

    # Total line
    stroke_color "000000"
    stroke_horizontal_line(
      page_width - total_line_width + 3,
      page_width,
      :at => column_top - row_height * row)

    # Checkbox
    checkbox_width = 5
    stroke_rectangle([-2, column_top - row_height * row + (row_height - checkbox_width) / 2], -checkbox_width, -checkbox_width)
  }

  # Note box
  notes_header_height = 20
  notes_top = column_top - row_height * row_count - notes_header_height
  notes_box_height = page_height - notes_top - notes_header_height
  stroke_color "AAAAAA"
  stroke_rectangle [0, notes_top], page_width, notes_box_height

  # Notes header
  fill_color "000000"
  draw_text "NOTES", :at => [0, notes_top + 2], :valign => :center

  # Note lines
  note_height = notes_box_height / note_count.to_f
  stroke_color "CCCCCC"
  1.upto(note_count - 1).each { |note|
    stroke_horizontal_line(
      0,
      page_width,
      :at => notes_top - (note_height * note))
  }

  # Footer
  fill_color "000000"
  font_size 8
  draw_text "Nicolas Marchildon 2016 ETT07", :at => [0, 0], :valign => :center
}

