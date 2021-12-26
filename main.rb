=begin Copyright 2021 shandor
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
=end


##begin class of typewriter
class TypeWriter

  attr_gtk

  def append_array(args)
    if args.state.out_text.length > args.state.max_len 
      new_line(args)
    end
    args.state.lines[args.state.line_cnt] = args.state.out_text
    args.state.cursor[:y] = args.state.line_cnt * -20 + 600
    args.state.cursor[:x] = (args.state.out_text.length * 10) + 10
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
    args.state.out_text = args.state.lines[args.state.line_cnt]
    args.state.lines[args.state.line_cnt] = args.state.out_text
  end

  def flash_cursor(args)
    args.outputs.labels << args.state.cursor
  end

  def append_space(args)
    args.state.out_text << " "
  end

  def delete_string(args)
    if args.state.out_text.length < 2 && args.state.line_cnt > 0
      remove_array_index(args)
      return
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
  $new_doc.state.max_len  ||= 58
  $new_doc.state.cursor   ||= { x: 20, y: 600, text: "_" }
  $new_doc.state.line_cnt ||= 0
  var_unter               ||= 100
  var_uver                ||= 20
  if args.state.tick_count % 100 > 50
      $new_doc.flash_cursor(args)
  end
  $new_doc.append_string(args) unless (args.inputs.keyboard.key_down.enter) && (( !args.inputs.text.empty?) && args.inputs.keyboard.key_down.space) && !args.inputs.keyboard.key_held.backspace
  $new_doc.append_space(args) unless (!args.inputs.keyboard.key.space)
  if args.inputs.keyboard.key_down.backspace
    var_unter = 100
    var_uver = 20
  elsif args.inputs.keyboard.key_held.backspace
    var_unter = 12
    var_uver = 2
  elsif (args.inputs.keyboard.key_down.backspace || args.inputs.keyboard.key_held.backspace) && args.inputs.keyboard.key_down.control
    var_unter = 2
    var_uver = 1
  end
  $new_doc.delete_string(args) if (args.inputs.keyboard.key_down.backspace) || (args.inputs.keyboard.key_held.backspace && $new_doc.state.line_cnt > -1 && args.state.tick_count % var_unter == var_uver )
  $new_doc.new_line(args) if args.inputs.keyboard.key_down.enter
  args.outputs.sprites << [10,20,600,600,"sprites/ui/binding_box_lettering.png"]
  args.outputs.sprites << [20,700-57,576,54,"sprites/ui/binding_box_menu.png"]
  args.outputs.lines   << [30,630,600-30,630]
  args.outputs.sprites << [600+17,20,20,600,"sprites/ui/vert_scroll_bar.png"]
  args.outputs.sprites << [654,20,600,600,"sprites/ui/binding_box_lettering.png"]
  args.outputs.sprites << [600+17,600,20,20,"sprites/ui/arrow_up.png"]
  args.outputs.sprites << [600+17,20,20,20,"sprites/ui/arrow_down.png"]
  args.outputs.labels << [650,700,"Line Length: #{$new_doc.state.out_text.length}"]
  args.outputs.labels << $new_doc.state.lines.map_with_index do |s, i|
      { x: 20, y: 600 - (i * 20), text: s }
  end
end