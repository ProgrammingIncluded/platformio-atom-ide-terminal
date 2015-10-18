{TextEditorView, View} = require 'atom-space-pen-views'

module.exports =
class RenameDialog extends View
  @content: () ->
    @div class: 'terminal-plus rename-dialog', =>
      @label 'Rename', outlet: 'promptText'
      @subview 'miniEditor', new TextEditorView(mini: true)
      @label 'Escape (Esc) to exit', style: 'float: left;'
      @label 'Enter (\u21B5) to accept', style: 'float: right;'

  initialize: (@statusIcon) ->
    atom.commands.add @element,
      'core:confirm': =>
        @statusIcon.updateName @miniEditor.getText().trim()
        @close()
      'core:cancel': => @cancel()
    @miniEditor.on 'blur', => @close()
    @miniEditor.getModel().setText @statusIcon.getName()
    @miniEditor.getModel().selectAll()

  attach: ->
    @panel = atom.workspace.addModalPanel(item: this.element)
    @miniEditor.focus()
    @miniEditor.getModel().scrollToCursorPosition()

  close: ->
    panelToDestroy = @panel
    @panel = null
    panelToDestroy?.destroy()
    atom.workspace.getActivePane().activate()

  cancel: ->
    @close()
