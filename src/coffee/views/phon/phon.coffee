define [
  'backbone',
  'three'
], (Backbone, THREE) ->

  class extends Backbone.View

    events:
      'mousedown': 'onMousedown'

    getRelativeMouse: (e) ->
      offset = @$el.offset()
      rel_x = e.clientX - offset.left
      rel_y = e.clientY - offset.top
      x: (rel_x / @$el.width()) * 2 - 1
      y: - (rel_y / @$el.height()) * 2 + 1

    onMousedown: (e) =>
      e.preventDefault()
      projector = new THREE.Projector()
      camera = @options.camera
      group = @options.group
      matrixView = @options.matrixView
      mouse = @getRelativeMouse(e) 

      vector = new THREE.Vector3 mouse.x, mouse.y, 0.5
      projector.unprojectVector(vector, camera)
      raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize())
      intersects = raycaster.intersectObjects(group.children, true)
      
      if intersects[0]
        cell = matrixView.findCellByMesh intersects[0].object
        if @selected_cell
          if cell is @selected_cell
            selected = cell.get('selected')
            cell.set 'selected', not selected
          else
            @selected_cell.set 'selected', false
            cell.set 'selected', true
        else
          cell.set 'selected', true
        @selected_cell = cell