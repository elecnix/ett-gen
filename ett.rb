#!/usr/bin/env ruby
require "prawn"
require "prawn/measurement_extensions"

Prawn::Document.generate("ett.pdf") {
  page_width = 550
  page_height = 730
  header_height = 18
  row_height = 20
  row_left_line_height = row_height * 0.7
  task_width = 350
  total_line_width = 40
  column_count = 10
  column_width = (page_width - task_width - total_line_width) / column_count.to_f
  row_count = 15
  note_count = 19
  checkbox_width = 5

  # Title
  stroke_color "aaaaaa"
  self.line_width = 0.2
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

  # Task columns
  column_top = header_top - header_height * 1.5
  0.upto(column_count - 1).each { |col|
    bleed_top = header_top - header_height
    column_left = task_width + col * column_width

    # Column shade
    fill_color(col % 2 == 0 ? "DDDDDD" : "FFFFFF")
    fill_rectangle(
        [column_left, bleed_top],
        column_width,
        row_count * row_height - column_top + bleed_top)

    # Left Bucket
    bucket(column_top, column_left, 15, 3)

    # Row bubbles
    0.upto(row_count - 1).each { |row|
      row_top = column_top - row_height * row

      # Left of line
      stroke_color "333333"
      stroke_vertical_line(
        row_top - row_height + row_left_line_height,
        row_top - row_height,
        :at => 0)

      # Task number (right line)
      stroke_color "333333"
      stroke_vertical_line(
        row_top - row_height + row_height * 0.1,
        row_top - row_height,
        :at => task_width - 50  )

      # Bubbles
      fill_color "FFFFFF"
      column_margin = column_width.to_f / 7
      column_inner_width = column_width.to_f - (column_margin * 2)
      bubble_hmargin = column_inner_width.to_f / 8
      bubble_width = (column_inner_width - bubble_hmargin * 3) / 4
      bubble_vmargin = row_height.to_f * 0.3
      bubble_height = row_height.to_f * 0.6
      undash
      0.upto(3).each { |bubble|
        bubble_left = column_left + column_margin + (bubble_width + bubble_hmargin) * bubble
        stroke_color "000000"
        fill_and_stroke_rounded_rectangle(
          [bubble_left, row_top - bubble_vmargin],
          bubble_width,
          bubble_height,
          bubble_width / 2)
        stroke_color "666666"
        1.upto(2).each { |sub|
          stroke_horizontal_line(
            bubble_left,
            bubble_left + bubble_width,
            :at => row_top - bubble_vmargin - sub * bubble_height / 3)
        }
      }
    }
  }
  # last bucket
  bucket(column_top, task_width + column_count * column_width, 15, 3)

  # Header
  fill_color "CCCCCC"
  fill_rectangle [0, header_top], page_width, header_height
  fill_color "000000"
  draw_text "TASKS", :at => [5, header_top - header_height + 5], :valign => :center
  draw_text "START TIME", :at => [270, header_top - header_height + 5], :valign => :center
  draw_text "DATE", :at => [375, header_top - header_height + 5], :valign => :center
  fill_color "FFFFFF"
  header_form_height = header_height * 0.8
  header_form_top = header_top - (header_height - header_form_height) / 2
  fill_rectangle [task_width - column_width, header_form_top], column_width * 2, header_form_height
  fill_rectangle [task_width + column_width * (column_count - 6), header_form_top], column_width * 6, header_form_height

  1.upto(row_count).each { |row|

    # Task line
    stroke_color "333333"
    stroke_horizontal_line(
      0,
      page_width - total_line_width,
      :at => column_top - row_height * row)

    # Total line
    stroke_color "000000"
    stroke_horizontal_line(
      page_width - total_line_width + 3,
      page_width - checkbox_width,
      :at => column_top - row_height * row)

    # Checkbox (left)
    stroke_color "333333"
    stroke_rectangle([-6, column_top - row_height * row + (row_left_line_height - checkbox_width) / 2.0], -checkbox_width, -checkbox_width)

    # Checkbox (right)
    stroke_color "666666"
    righ_checkbox_width = checkbox_width * 0.75
    stroke_rectangle([page_width, column_top - row_height * row + (row_left_line_height - righ_checkbox_width) / 2.0], -righ_checkbox_width, -righ_checkbox_width)
  }

  # Note box
  notes_header_height = 20
  notes_top = column_top - row_height * row_count - notes_header_height
  notes_box_height = page_height - notes_top - notes_header_height
  stroke_color "000000"
  stroke_rectangle [0, notes_top], page_width, notes_box_height

  # Notes header
  fill_color "000000"
  draw_text "NOTES", :at => [0, notes_top + 2], :valign => :center

  # Note lines
  note_height = notes_box_height / note_count.to_f
  stroke_color "AAAAAA"
  1.upto(note_count - 1).each { |note|
    stroke_horizontal_line(
      0,
      page_width,
      :at => notes_top - (note_height * note))
  }

  # Footer
  fill_color "000000"
  font_size 6
  draw_text "Nicolas Marchildon 2016 ETT08", :at => [0, 0], :valign => :center
}

