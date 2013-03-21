define [
  'underscore',
  'backbone'
], (_, Backbone) ->

  class extends Backbone.View

    attributes:
      class: 'tools'

    events:
      'click .move-camera': 'toggleMoveCamera'

    constructor: (matrixView) ->
      Backbone.View.apply @
      @matrixView = matrixView

    toggleMoveCamera: ->
      method = if @_toggleMoveCamera then 'off' else 'on'
      $(document)[method] 'mousedown', @initMoveCamera
      @_toggleMoveCamera = not @_toggleMoveCamera

    initMoveCamera: (e) =>
      $doc = $(document)
      matrix_view = @matrixView
      start_x = e.clientX
      start_y = e.clientY
      start_y_rotation = matrix_view.rotation.y
      start_x_rotation = matrix_view.rotation.x

      move = (move_e) ->
        diff_x = move_e.clientX - start_x
        diff_y = move_e.clientY - start_y
        matrix_view.rotation.y = start_y_rotation + diff_x * .002
        matrix_view.rotation.x = start_x_rotation + diff_y * .002

      $doc.on 'mousemove', move
      $doc.on 'mouseup', ->
        $doc.off 'mouseup', arguments.callee
        $doc.off 'mousemove', move

    render: ->
      @$el.append '<button class="move-camera">move camera</button>'
      @