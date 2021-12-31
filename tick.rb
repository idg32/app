# Copyright 2021 shandor
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.




def metadata_file_path
  "app/words.txt"
end

def is_word word, args
    
    if  args.state.words[word.upcase] == true
      puts true
			return true
		else
			return false
		end
  # file = gtk.read_file("words.txt") 
  # state.world = exported_world.each_line.map do |l|
  #   priny l[-1]
  #   # file.each do |file|
  #   #   print file
  #   # end
  # end
end	

# def identify_spelling_opiton args, word
#   return args.state.words.select {|k,v| k.match word == true}.keys
# end

# def draw_red_red_line x,y,len, args
#   args.outputs.line << (x,y,x-len,y)
# end

def do_things args
    if args.state.tick_count % 100 > 50
      $new_doc.flash_cursor(args)
  end

  if args.inputs.mouse.click && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.check_spelling )
    $button_soft_ware.state.identifier = "SPELL CHECK"
    puts args.state.display_text
    $new_doc.state.broken_words = []
    temp = $new_doc.state.lines.join(" ")
    puts temp
    mak = -1
    len = []
    temp.split.each_with_index do |line, index|
      len = (args.gtk.calcstringbox line)
      puts len if !is_word(line.tr('?,./!@#$%^&*()_+',''), args)

        xrer = 20 * index#( len[0] - 10) + 20 * index
      puts line
      $new_doc.state.broken_words << "#{line} #{identify_spelling_option(args, line.upcase)}"if !is_word(line.tr('?,./!@#$%^&*()_+',''), args) && line != ""

      end
  end

  if $button_soft_ware.state.identifier == "FILE NAME" && !args.inputs.text.empty?
    $new_doc.write_file_name(args)
  end

  if args.state.tick_count % 10 == 1
    if !args.inputs.mouse.down && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.buttons_scroll_bar_up  )
      args.state.up_arrow = "sprites/ui/arrow_up_hover.png" 
    elsif args.inputs.mouse.down && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.buttons_scroll_bar_up  )
      args.state.up_arrow = "sprites/ui/arrow_up_pressed.png" 
    else
      args.state.up_arrow = "sprites/ui/arrow_up.png"
    end
  end

  if args.state.tick_count % 2 == 1
    if !args.inputs.mouse.down && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.buttons_scroll_bar_down  )
      args.state.up_down = "sprites/ui/arrow_down_hover.png" 
    elsif args.inputs.mouse.down && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.buttons_scroll_bar_down )
      args.state.up_down = "sprites/ui/arrow_down_pressed.png" 
    else
      args.state.up_down = "sprites/ui/arrow_down.png"
    end

    if !args.inputs.mouse.down && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.scroll_bar ) && args.state.scroll_enable == false
      $button_soft_ware.state.scroll_bar[:path] = "sprites/ui/vert_scroll_bar_hover.png" 
    elsif $button_soft_ware.state.identifier == "SCROLL BAR" && args.inputs.mouse.down && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.scroll_bar )
      $button_soft_ware.state.scroll_bar[:path] = "sprites/ui/vert_scroll_bar_pressed.png" 
      args.state.scroll_enable = true
    elsif $button_soft_ware.check_button_inside( args, $button_soft_ware.state.scroll_bar  ) == false
      $button_soft_ware.state.scroll_bar[:path] = "sprites/ui/vert_scroll_bar.png"
      args.state.scroll_enable = false
    end
  end

  if args.state.scroll_enable == true && $button_soft_ware.check_button_inside( args, $button_soft_ware.state.scroll_bar ) && args.inputs.mouse.down
    $button_soft_ware.state.scroll_bar[:y] += (args.inputs.mouse.point.y).clamp(args.state.display_cur.clamp(1,29) * 38,560).idiv(20)
    $button_soft_ware.state.scroll_bar[:y] = $button_soft_ware.state.scroll_bar[:y].clamp(args.state.display_cur.clamp(1,29) * 38,560)
    if ($button_soft_ware.state.scroll_bar[:y] - (args.inputs.mouse.point.y)).sign < 0 && $new_doc.state.display_cur > 0
      args.state.display_cur -= 1 
      $new_doc.state.cursor[:y] -= 20 
    end
    if ($button_soft_ware.state.scroll_bar[:y] - (args.inputs.mouse.point.y)).sign > 0 && $new_doc.state.display_cur < $new_doc.state.display_cnt
      args.state.display_cur += 1 
      $new_doc.state.cursor[:y] += 20 
    end
  elsif !$button_soft_ware.check_button_inside( args, $button_soft_ware.state.scroll_bar )
    args.state.scroll_enable = false
  end

  # if args.state.tick_count % 10 == 1
  #end
  args.state.last_key = args.inputs.text[-1] unless args.inputs.text.empty?


  #clicky click
  if args.inputs.mouse.down
    $button_soft_ware.check_button( args, $button_soft_ware.state.button_list )
    if args.state.display_cur != 0  && $button_soft_ware.state.identifier == "UP ARROW"
      args.state.last_y = $new_doc.state.cursor[:y]
      args.state.display_cur -= 1 
      $new_doc.state.cursor[:y] -= 20 unless $new_doc.state.cursor[:y] <= 32
      $new_doc.state.cursor[:y] = args.state.last_y if $new_doc.state.cursor[:y] <= 32

      $button_soft_ware.state.scroll_bar[:y] += 20 if $button_soft_ware.state.scroll_bar[:y] < 580
    end
    if args.state.display_cur < args.state.display_cnt && $button_soft_ware.state.identifier == "DOWN ARROW"
      args.state.last_y = $new_doc.state.cursor[:y]
      args.state.display_cur += 1 
      $new_doc.state.cursor[:y] += 20 if args.state.display_cur < args.state.display_max
      $button_soft_ware.state.scroll_bar[:y] -= 20 if $button_soft_ware.state.scroll_bar[:y] > 32 
      $new_doc.state.cursor[:y] = args.state.last_y if args.state.display_cur == args.state.display_max

    end
    if $button_soft_ware.state.identifier == "DARK THEME"
      $new_doc.state.color_cur = 0
    end
    if $button_soft_ware.state.identifier == "RESTART"
      $new_doc = nil
      $button_soft_ware = nil
      $gtk.reset
    end
    if $button_soft_ware.state.identifier == "QUIT"
      $gtk.request_quit
    end
    if $button_soft_ware.state.identifier == "APPEND"
      $new_doc.write_file_doc(args)
    end
    if $button_soft_ware.state.identifier == "OPEN"
      $new_doc.state.lines = $new_doc.open_file_doc(args).split("\n")
      $new_doc.state.line_cnt = $new_doc.state.lines.size
      $new_doc.state.cursor[:y] = $new_doc.state.lines.size  * -20 + 600
    end
    if $button_soft_ware.state.identifier == "FILE NAME"
      $new_doc.state.file_name_txt = ""
    end
  end

  if args.inputs.keyboard.key_down.one && $button_soft_ware.state.identifier != "DOCUMENT"
    $new_doc.state.color_cur = 1
  elsif args.inputs.keyboard.key_down.zero && $button_soft_ware.state.identifier != "DOCUMENT"
    $new_doc.state.color_cur = 0
  end


  args.state.display_cnt = $new_doc.state.line_cnt
  args.state.display_text = $new_doc.state.lines[0..args.state.display_cur]

  if args.inputs.keyboard.key_down.tab 
    puts args.state.display_text
    $new_doc.state.broken_words = []
    temp = $new_doc.state.lines.join(" ")
    puts temp
    mak = -1
    len = []
    temp.split.each_with_index do |line, index|
      len = (args.gtk.calcstringbox line)
      puts len if !is_word(line.tr('?,./!@#$%^&*()_+',''), args)

        xrer = 20 * index#( len[0] - 10) + 20 * index
      puts line
      $new_doc.state.broken_words << "#{line} #{identify_spelling_option(args, line.upcase.replace("-?,.!@#$%^&*()_+",''))}"if !is_word(line.replace("?,.!@#$%^&*()_+-",''), args) && line != ""

      end
  end

  if $button_soft_ware.state.identifier == "DOCUMENT"
    
    if !args.inputs.text.empty? || args.inputs.keyboard.key_down.enter || args.inputs.keyboard.key_held.backspace
      args.state.last_y = $new_doc.state.cursor[:y]
      $new_doc.append_string(args)
      $new_doc.state.cursor[:y] = args.state.last_y if args.state.display_cur > 0
    end
    $new_doc.append_space(args) unless (!args.inputs.keyboard.key.space)
    #get the array at n element to n_fin elemetn
  end

  args.state.display_text = $new_doc.state.lines[args.state.display_cur..args.state.display_cnt]

  if args.inputs.keyboard.key_down.backspace
    var_unter = 100
    var_uver = 20
  elsif args.inputs.keyboard.key_held.backspace
    var_unter = 12
    var_uver = 2
  elsif (args.inputs.keyboard.key_down.backspace || args.inputs.keyboard.key_held.backspace) && args.inputs.keyboard.key_held.control
    var_unter = 2
    var_uver = 1
  end

  if (args.inputs.keyboard.key_down.backspace) || (args.inputs.keyboard.key_held.backspace && $new_doc.state.line_cnt > -1 && args.state.tick_count % var_unter == var_uver )
    $button_soft_ware.state.scroll_bar[:y] += 20 if $button_soft_ware.state.scroll_bar[:y] < 560 if args.state.last_y != $new_doc.state.cursor[:y]
    
    args.state.last_y = $new_doc.state.cursor[:y]
    $new_doc.delete_string(args) 
    args.state.display_cur += 1 if $new_doc.state.out_text.include?('ABCDEFGHIJKLMNOPQRSTUVWXYZ.,;"?/') && $new_doc.state.line_cnt > 27
    $new_doc.state.cursor[:y] = args.state.last_y if args.state.display_cur > 0
  end
  if args.inputs.keyboard.key_down.enter && $button_soft_ware.state.identifier == "DOCUMENT"
    args.state.display_cur -= 1 if $new_doc.state.line_cnt > 27
    $new_doc.new_line(args) 
    #$new_doc.state.cursor[:y] += 20 if $new_doc.state.line_cnt > 28
  end
end



def tick args
  $new_doc ||= TypeWriter.new
  $button_soft_ware ||= BUttonWorthingtonPaks.new
  args.state.tick_count ||= 0
  load_file(args) if args.state.tick_count == 1
  $button_soft_ware.args = args
  $button_soft_ware.init(args) if args.state.tick_count == 0
  $new_doc.args = args
  $new_doc.state.file_name_txt ||= "default"
  $new_doc.state.colors ||= [[156,153,164],[67,67,67]]
  $new_doc.state.color_cur ||= 1
  $new_doc.state.lines    ||= [""]
  $new_doc.state.out_text ||= ""
  $new_doc.state.max_len  ||= 58
  $new_doc.state.cursor   ||= { x: 20, y: 600, text: "_" }
  $new_doc.state.line_cnt ||= 0
  var_unter               ||= 100
  var_uver                ||= 20
  $new_doc.state.broken_words_cnt ||= 0
  $new_doc.state.broken_words ||= []
  $new_doc.state.copy_lines ||= []
  args.state.display_text ||= [""]
  args.state.up_down ||= "sprites/ui/arrow_down.png"
  args.state.up_arrow ||= "sprites/ui/arrow_up.png"
  args.state.vert_scroll ||= "sprites/ui/vert_scroll_bar.png"
  args.state.display_cnt ||= 0
  args.state.display_cur ||= 0
  args.state.display_max ||= 29
  args.state.scroll_enable    ||= false
  
  do_things(args) if args.state.tick_count > 1

  args.outputs.sprites << [10,20,600,600,"sprites/ui/binding_box_lettering.png",0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.sprites << [20,700-57,576,54,"sprites/ui/binding_box_menu.png",0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.sprites << [20,700-57,48,48,"sprites/ui/append.png"]
  args.outputs.sprites << [140,700-57,48,48,"sprites/ui/open.png"]
  args.outputs.sprites << [280,700-57,48,48,"sprites/ui/spellcheck.png"]
  args.outputs.sprites << [400,700-57,48,48,"sprites/ui/restart.png"]
  args.outputs.sprites << [520,700-57,48,48,"sprites/ui/Close.png"]




  args.outputs.lines   << [30,630,600-30,630]
  args.outputs.sprites << [600+17,20,20,600,"sprites/ui/vert_scroll_bar_bg.png",0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.sprites << $button_soft_ware.state.scroll_bar if args.state.tick_count > 2
  args.outputs.sprites << [654,20,600,600,"sprites/ui/binding_box_lettering.png",0,$new_doc.state.colors[$new_doc.state.color_cur]]
  #this is the spelling error box
  args.outputs.sprites << [674,480,560,100,"sprites/ui/binding_box_lettering.png",0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.sprites << [654,560,20,20,args.state.up_arrow,0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.sprites << [654,480,20,20,args.state.up_down,0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.sprites << $button_soft_ware.state.dark_theme if args.state.tick_count > 2
  args.outputs.labels << [680,600,"DARK THEME",0,255,255,255,255]



  args.outputs.sprites << [600+17,600,20,20,args.state.up_arrow,0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.sprites << [600+17,20,20,20,args.state.up_down,0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.labels << [650,700,"Line Length: #{$new_doc.state.out_text.length}"]
  args.outputs.labels << [900,650,"LAST KEY: #{args.state.last_key}"]
  args.outputs.labels << [900,700,"Button Sel: #{$button_soft_ware.state.identifier}"]
  args.outputs.labels << [650,650,"Line Count: #{$new_doc.state.line_cnt}"]
  args.outputs.labels << [650,675,"Current Line Min: #{args.state.display_cur}"]
  args.outputs.sprites << [675,400,200,50,"sprites/ui/binding_box_lettering.png",0,$new_doc.state.colors[$new_doc.state.color_cur]]
  args.outputs.labels << [680,435,$new_doc.state.file_name_txt]



  args.state.display_text.map_with_index do |s, i|
    args.outputs.labels << { x: 20, y: 600 - (i * 20), text: s  }
  end

  long_strings_split = args.string.wrapped_lines $new_doc.state.broken_words.join(" ") , 49 unless $new_doc.state.broken_words.empty?
  if !$new_doc.state.broken_words.empty? 
    args.outputs.labels << long_strings_split.map_with_index do |s, i| 
      { x: 684, y: 580 - (i * 20), text: s }
    end
  end
  #args.outputs.labels << {x: 684, y: 580, text: long_strings_split} unless $new_doc.state.broken_words == []
  args.outputs.labels << {x: 674, y: 200, text: "#{args.inputs.mouse.point.x} : #{args.inputs.mouse.point.y} : #{args.inputs.mouse.click}"}

  # limt = $new_doc.state.broken_words args.inputs.text
  # for i in 0...limt.size
  #   args.outputs.lines << [limt[i][:x] + i * 20,limt[i][:y],limt[i][:x] + (limt[i][:length]),limt[i][:y], 255, 0, 0, 255] unless limt[i] == nil
  # end
end

def load_file args
  args.state.words = {}
  $word_array ||= []
  for i in 0...24
    $word_array << []
  end
  
  index = 0
  file = $gtk.read_file metadata_file_path()
    file.each_line do |line|
   	  args.state.words[line.upcase.strip] = true
      $word_array[0] << line.upcase.chomp.strip
		end
    
end


def identify_spelling_option args, key
  $word_array.map_2d do |row,col,value|
    p value
    return "#{value}?" if value.upcase.start_with?(key.upcase) == true
  end
  return "N/A?"
end