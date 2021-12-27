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
  
  class BUttonWorthingtonPaks
    attr_gtk
  
    def init(args)
      state.buttons_scroll_bar_up = {
        x: 617, y: 600, h: 30, w: 30 
      }
      state.lettering_box = {
        x: 10, y: 20, h: 600, w: 600
      }
      state.buttons_scroll_bar_down = {
        x: 617, y: 20, h: 20, w: 20
      }
      state.name = ["UP ARROW","DOWN ARROW","DOCUMENT"]#, "DOCUMENT"]
      state.button_list = [state.buttons_scroll_bar_up,state.buttons_scroll_bar_down,state.lettering_box]#,state.lettering_box]
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