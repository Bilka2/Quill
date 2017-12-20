--[[
   A file that holds all the functions this mod uses for gui creation.
--]]

local mod_gui = require("mod-gui")

--Displays a gui for renaming a note
function makeRenameNoteGUI(gui)
   local player = game.players[gui.player_index]
   local dropDown = gui["quill-notes-list-frame"]["quill-notes-list-drop-down"]
   local renameNoteFrame = gui.add{
      type = "frame",
      direction = "horizontal",
      name = "quill-rename-note-frame",
      caption = "Rename " .. dropDown.items[dropDown.selected_index]
   }
   renameNoteFrame.add{
      type = "label",
      caption = {"gui.quill-rename-note-label"},
      name = "quill-rename-note-label"
   }
   renameNoteFrame.add{
      type = "textfield",
      name = "quill-rename-note-text-field"
   }
   renameNoteFrame.add{
      type = "sprite-button",
      style = "quill_buttons",
      sprite = "quill-confirm-sprite",
      tooltip = {"gui.quill-confirm-rename-button-tooltip"},
      name = "quill-confirm-rename-button"
   }

   renameNoteFrame.add{
      type = "sprite-button",
      style = "quill_buttons",
      sprite = "quill-cancel-sprite",
      name = "quill-cancel-rename-button"
   }
   return renameNoteFrame
end


--Makes a gui for displaying an existing note
function makeExistingNoteGUI(gui)

   local player = game.players[gui.player_index]
   local existingNoteFrame= gui.add{
      type = "frame",
      direction = "vertical",
      name = "quill-existing-note-frame",
      caption = global.player_notes[gui.player_index][gui["quill-notes-list-frame"]["quill-notes-list-drop-down"].selected_index].name
   }

   existingNoteFrame.style.minimal_width = 450
   existingNoteFrame.style.maximal_height= 600
   existingNoteFrame.style.minimal_height = 500
   existingNoteFrame.style.maximal_width = 500

   local textBox= existingNoteFrame.add{
      type = "text-box",
      name = "quill-note-text-box",
   }

   textBox.word_wrap = true
   textBox.style.width = 400
   textBox.style.height= 400
   textBox.text = global.player_notes[gui.player_index][gui["quill-notes-list-frame"]["quill-notes-list-drop-down"].selected_index].contents

   local saveCancelFlow= existingNoteFrame.add{
      type = "flow",
      direction = "horizontal",
      name = "quill-save-cancel-flow"
   }
   saveCancelFlow.add{
      type = "sprite-button",
      style = "quill_buttons",
      sprite = "quill-confirm-sprite",
      tooltip = {"gui.quill-save-note-button-tooltip"},
      name = "quill-save-note-button"
   }
   saveCancelFlow.add{
      type = "sprite-button",
      style = "quill_buttons",
      sprite = "quill-cancel-sprite",
      tooltip = {"gui.quill-cancel-note-button-tooltip"},
      name = "quill-cancel-note-button"
   }
   saveCancelFlow.add{
      type = "button",
      caption = {"gui.quill-print-note-to-chat-button-caption"},
      tooltip = {"gui.quill-print-note-to-chat-button-tooltip"},
      name = "quill-print-note-to-chat-button"
   }

   gui["quill-notes-list-frame"].style.visible = false --hide note list

   return existingNoteFrame
end


--Creates a gui for a new note.
function makeNewNoteGUI(gui)
   local newNoteFrame= gui.add{
      type = "frame",
      direction = "vertical",
      name = "quill-new-note-frame",
      caption = {"gui.quill-new-note-frame-caption"}
   }

   newNoteFrame.style.width = 450
   newNoteFrame.style.maximal_height= 550
   newNoteFrame.style.minimal_height = 500

   local textBox= newNoteFrame.add{
      type = "text-box",
      name = "quill-note-text-box",
   }
   textBox.text = "Type your note here. Notes are saved when you hit save."
   textBox.word_wrap = true
   textBox.style.width = 400
   textBox.style.height= 400

   local saveCancelFlow= newNoteFrame.add{
      type = "flow",
      direction = "horizontal",
      name = "quill-save-cancel-flow"
   }
   saveCancelFlow.add{
      type = "sprite-button",
      style = "quill_buttons",
      sprite = "quill-confirm-sprite",
      tooltip = {"gui.quill-save-new-note-button-tooltip"},
      name = "quill-save-note-button"
   }
   saveCancelFlow.add{
      type = "sprite-button",
      style = "quill_buttons",
      sprite = "quill-cancel-sprite",
      tooltip = {"gui.quill-cancel-note-button-tooltip"},
      name = "quill-cancel-note-button"
   }

   gui["quill-notes-list-frame"].style.visible = false --hide note list

   return newNoteFrame
end


--Regenerates the UI of the mod completely, in the event of init or a new player.
function nukeAndRegenUI(player)
   local lGui = mod_gui.get_button_flow(player)
   local cGui = player.gui.center

   --Clear the existing mod's GUI
   if lGui["quill-open-notes"] then
      lGui["quill-open-notes"].destroy()
   end
   if cGui["quill-notes-list-frame"] then
      cGui["quill-notes-list-frame"].destroy()
   end
   if cGui["quill-note-frame"] then
      cGui["quill-note-frame"].destroy()
   end

   lGui.add{ --add the open notes button
      type = "sprite-button",
      tooltip = {"gui.quill-open-notes-tooltip"},
      name = "quill-open-notes",
      sprite = "quill-notes-sprite",
      style = "quill_small_buttons"
   }
   
   local noteListFrame =  constructNotesList(cGui)
end

function constructNotesList(gui)
   local noteListFrame= gui.add{
      type = "frame",
      caption = "Notes",
      name = "quill-notes-list-frame",
      direction = "vertical"
   }
   noteListFrame.style.visible = false --set to hide initially

   noteListFrame.add{
      type = "drop-down",
      name = "quill-notes-list-drop-down",
   }
   -- Add operation buttons, for stuff like new notes, deleting notes, etc.
   local operationsFlow = noteListFrame.add{
      type = "flow",
      direction = "horizontal",
      name = "quill-note-operations-flow",
   }

   operationsFlow.add{
      type = "sprite-button",
      name = "quill-open-note-button",
      style = "quill_buttons",
      sprite = "quill-open-note-sprite",
      tooltip = {"gui.quill-open-note-button"}
   }

   operationsFlow.add{
      type = "sprite-button",
      name = "quill-new-note-button",
      style = "quill_buttons",
      sprite = "quill-add-note-sprite",
      tooltip = {"gui.quill-new-note-button"}
   }
   operationsFlow.add{
      type = "sprite-button",
      name = "quill-delete-note-button",
      style = "quill_buttons",
      sprite = "quill-delete-sprite",
      tooltip = {"gui.quill-delete-note-button"}
   }
   operationsFlow.add{
      type = "sprite-button",
      name = "quill-rename-note-button",
      style = "quill_buttons",
      sprite = "quill-rename-note-sprite",
      tooltip = {"gui.quill-rename-note-button"}
   }
   noteListFrame.add{
      type = "sprite-button",
      name = "quill-sort-button",
      style = "quill_buttons",
      sprite = "quill-sort-sprite",
      tooltip = {"gui.quill-sort-button"}
   }


   return noteListFrame
end
