##begin class of typewriter
class TypeWriter

  attr_gtk

  def append_array(args)
    if args.state.out_text.length > 125
      new_line(args)
    end
    args.state.lines[args.state.line_cnt] = args.state.out_text
    args.state.cursor[:y] = args.state.line_cnt * -20 + 600
    args.state.cursor[:x] = args.state.out_text.length * 10
  end

  def new_line(args)
    args.state.out_text.slice!(-1,1) if args.state.out_text[-1] == "_"
    args.state.lines[args.state.line_cnt] = args.state.out_text
    args.state.line_cnt += 1 
    args.state.out_text = ""
  end

  def remove_array_index(args)
    args.state.lines.delete_at(args.state.line_cnt)
    args.state.line_cnt -= 1
    args.state.lines[args.state.line_cnt] = args.state.out_text
  end

  def flash_cursor(args)
    args.outputs.labels << args.state.cursor
  end

  def append_space(args)
    args.state.out_text << " "
  end

  def delete_string(args)
    if args.state.out_text.length < 2 && args.state.tick_count % 21 == 1 && args.state.line_cnt > 0
      remove_array_index(args) 
    end
    args.state.out_text.slice!(-1,1)
    append_array(args)
  end

  def append_string(args)
    args.state.out_text << args.inputs.text.join
    append_array(args)
  end
end

$new_doc = TypeWriter.new


def tick args

  $new_doc.args = args
  $new_doc.state.lines    ||= [""]
  $new_doc.state.out_text ||= ""
  $new_doc.state.cursor   ||= { x: 10, y: 600, text: "_" }
  $new_doc.state.line_cnt ||= 0
  if args.state.tick_count % 100 > 50
      $new_doc.flash_cursor(args)
  end
  $new_doc.append_string(args) unless (args.inputs.keyboard.key_down.enter) && (( !args.inputs.text.empty?) && args.inputs.keyboard.key_down.space) && !args.inputs.keyboard.key_held.backspace
  $new_doc.append_space(args) unless (!args.inputs.keyboard.key.space)
  $new_doc.delete_string(args) if args.inputs.keyboard.key_down.backspace && $new_doc.state.line_cnt > -1 || (args.inputs.keyboard.key_held.backspace && $new_doc.state.line_cnt > -1 && args.state.tick_count % 100 > 50 )
  $new_doc.new_line(args) if args.inputs.keyboard.key_down.enter
  args.outputs.labels << [10,700,"Line Length: #{$new_doc.state.out_text.length}"]
  args.outputs.labels << $new_doc.state.lines.map_with_index do |s, i|
      { x: 10, y: 600 - (i * 20), text: s }
  end
end