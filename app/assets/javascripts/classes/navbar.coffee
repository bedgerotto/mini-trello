window.App ||= {}
window.App.Navbar ||= {}

class App.Navbar
  constructor: (navbar = {}) ->
    @vm = new Vue
      el: '#navigation'
      data:
        projectName: 'Select your project'
        enProjEdit: false
        projectId: false
        projects: []
        selectProject: null
      created: ->
        $.get('project/get')
          .then(
            (res) =>
              console.log(res)
              @projects = res
          ).fail(
            (err) ->
              console.log(err)
          )
      methods:
        enableEdit: ->
          @enProjEdit = !@enProjEdit
        updateProject: (projectName) ->
          $.ajax({
            url: 'project/'+@projectId+'/update'
            method: 'put'
            data: {name: projectName}
          }).done(
            (res) ->
              if (res.data)
                @successAlert('Project successfully update');
                @enableEdit();
                @projects = @projects.filter(
                  (project) ->
                    if(project.id == @projectId)
                      return false
                    return true
                )
                @projects.push({id: @projectId, label: projectName})
              else
                @successAlert('Fail to update Project')
          ).fail(
            (res) ->
                console.log(res)
          )
        changeProject: ->
          $('#projectModal').modal('show')
        newProject: ->
          $('#projectModal').modal('hide')
          $('#newProjectModal').modal('show')
        saveNewProject: =>
          $.post('project/store', {name: $('#newProjectName').val()})
            .then(
              (res) ->
                message = 'The Project creation failed! ';
                if (res.data.project.id)
                    @projects.push({id: res.data.project.id, label: res.data.project.name});
                    message = 'The Project was successfully created! ';

                @successAlert(message);

                $('#projectModal').modal('show');
                $('#newProjectModal').modal('hide');
            ).fail(
              (err) ->
                @errorAlert('The Project creation failed! ')
                console.log(err)
              )
        selectProject: =>
          if ($('#projectDropdown :selected').text())
              @histories = [];
              
              @projectId = select.id;
              @projectName = select.label
          $http.get('project/'+select.id+'/histories').then(
              function(histories) {
                // set histories to scope
                $scope.histories['pending'] = (histories.data.pending.length > 0) ? JSON.parse(histories.data.pending) : {};
                $scope.histories['started'] = (histories.data.started.length > 0) ? JSON.parse(histories.data.started) : {};
                $scope.histories['delivered'] = (histories.data.delivered.length > 0) ? JSON.parse(histories.data.delivered) : {};
                // Hides modal
                $('#projectModal').modal('hide');
              },
              function(err) {
                  // Log if had error
                  console.log(err);
              }
          )
        }

        successAlert: (msg) ->
          $('.top-right').notify({message: {text: msg}, type: 'success'}).show()
        errorAlert: (msg) ->
          $('.top-right').notify({message: {text: msg}, type: 'danger'}).show()