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



class TypeWriter

    attr_gtk

    def write_file_doc(args)
      this_new_line ||= []
      puts args.state.lines[0]
      for i in 0...args.state.lines.size 
        this_new_line << args.state.lines[i][args.state.character_name_txt.length+7..-1]
      end
      args.gtk.write_file "exports/#{args.state.file_name_txt}/dialogue-#{args.state.file_name_txt}.txt",  this_new_line.join("\n")
      args.gtk.write_file "exports/#{args.state.file_name_txt}/dialogue-array-#{args.state.file_name_txt}.txt",  args.state.lines.join("\n")
      args.gtk.write_file "exports/#{args.state.file_name_txt}/character-#{args.state.file_name_txt}.txt", args.state.character_name_txt
      args.gtk.append_file "exports/register.txt", "#{args.state.file_name_txt}" + " \n" unless args.state.registry.include?(args.state.file_name_txt)
    end

    def get_register(args)
      return args.gtk.read_file "exports/register.txt" unless nil
      return ""
    end

    def open_file_doc(args, ch)
      args.state.registry = get_register(args).split("\n") unless nil
      args.gtk.append_file "exports/register.txt", "#{args.state.file_name_txt}" + " \n" unless args.state.registry.join("\n").include?(args.state.file_name_txt)
      return args.gtk.read_file "exports/#{args.state.file_name_txt}/character-#{args.state.file_name_txt}.txt" if ch == 0
      return args.gtk.read_file "exports/#{args.state.file_name_txt}/dialogue-array-#{args.state.file_name_txt}.txt" if ch == 1
    end
  
    def append_array(args)
      if args.state.out_text.length > args.state.max_len 
        new_line(args)
      end
      args.state.lines[args.state.line_cnt] = args.state.out_text
      args.state.cursor[:y] = args.state.line_cnt * -20 + 600 if args.state.line_cnt < 27
      args.state.cursor[:x] = (args.state.out_text.length * 10) + 10 
    end
  
    def new_line(args)
      args.state.lines[args.state.line_cnt] = args.state.out_text
      args.state.line_cnt += 1 
      args.state.out_text = "#{args.state.character_name_txt}[#{args.state.line_cnt}] = "
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
  
    def write_file_name(args)
      args.state.file_name_txt << args.inputs.text.join('')
    end

    def append_string(args)
      args.state.out_text << args.inputs.text.join
      append_array(args)
    end

    def append_character_name(args)
      args.state.character_name_txt << args.inputs.text.join
      args.state.out_text = args.state.character_name_txt + "[#{args.state.line_cnt}] = "
    end
  end
  
  class BUttonWorthingtonPaks
    attr_gtk
  
    def init(args)
      len = args.gtk.calcstringbox "DARK THEME"
      len1 = args.gtk.calcstringbox "LIGHT THEME"
      state.buttons_scroll_bar_up ||= {
        x: 617, y: 600, h: 30, w: 20 
      }
      state.lettering_box ||= {
        x: 10, y: 20, h: 600, w: 600
      }
      state.buttons_scroll_bar_down ||= {
        x: 617, y: 20, h: 20, w: 20
      }
      state.scroll_bar ||= {
        x: 617,y: 560, w: 20, h: 40, path: "sprites/ui/vert_scroll_bar.png"
      }
      state.check_spelling ||= {
        x: 280,y: 700-57,w: 48,h: 48
      }
      state.dark_theme ||= {
        x: 680, y: 580, w: len[0] , h: 30, path: "sprites/ui/binding_box_lettering.png"
      }
      state.light_theme ||= {
        x: 820, y: 580, w: len1[0] , h: 30, path: "sprites/ui/binding_box_lettering.png"
      }
      state.restart ||= {
        x: 400,y: 643,w: 48,h: 48
      }
      state.quit ||= {
        x: 520,y: 700-57,w: 48,h: 48
      }
      state.append ||= {
        x: 20,y: 700-57,w: 48,h: 48
      }
      state.open_doc ||= {
        x: 140,y: 700-57,w: 48,h: 48
      }
      state.file_name ||= {
        x: 675,y: 400,w: 200,h: 50
      }
      state.character_name ||= {
        x: 675,y: 300,w: 350,h: 50
      }
      state.file_list ||= {
        x: 680,y: 60, w:400, h:200
      }
      state.name = ["UP ARROW","DOWN ARROW","DOCUMENT","SCROLL BAR","CHECK YOUR SPELLING","DARK THEME","RESTART","QUIT","APPEND","OPEN","FILE NAME","CHAR NAME","LIGHT THEME","FILE LIST"]#, "DOCUMENT"]
      state.button_list = [state.buttons_scroll_bar_up,state.buttons_scroll_bar_down,state.lettering_box,state.scroll_bar,state.check_spelling,state.dark_theme,state.restart,state.quit,state.append,state.open_doc,state.file_name,state.character_name,state.light_theme,state.file_list     ]#,state.lettering_box]
      state.identifier = "N/A"
    end
  
    def check_button args, button
      #ind = 0
      button.map_with_index do |n, i|
        if args.inputs.mouse.inside_rect?(n)
          state.identifier = state.name[i]
          return
        else 
          state.identifier = "N/A"
        end
        #ind += 1
      end
    end

    def check_button_inside args, button
      #ind = 0
        if args.inputs.mouse.inside_rect?(button)
          #state.identifier = state.name[i]
          return true
        else 
          return false
        end
    end
  end

module EnglishDictionary

	@@words = {}

	def self.load_words()
		File.open("words.txt") do |file|
			file.each do |line|
		 		@@words[line.slice!(/ /)] = true
			end
		end
	end

  

end