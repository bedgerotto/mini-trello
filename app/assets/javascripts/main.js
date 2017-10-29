// initialize angular module
var app = angular.module('miniTrello', ['dragularModule']);

// percentage filter
app.filter('percentage', ['$filter', function ($filter) {
  return function (input, decimals) {
    return $filter('number')(input, decimals) + '%';
  };
}]);

// initialize angular controller
app.controller('MainCtrl', ['$scope', '$http', '$filter', '$element', 'dragularService', function($scope, $http, $filter, $element, dragularService) {
    // Defining default label when no project was selected
    $scope.history = {deadline: '', tasks: []};
    $scope.projectName = "Select your project"
    $scope.enProjEdit = false;
    $scope.update = false;
    $scope.tasks = [];
    $scope.taskPercent = 0;

    $scope.percent = function() {
      var done = $scope.history.tasks.filter(function(tasks){
        if (tasks.done) {
          return true
        }
        return false
      });

      $scope.taskPercent = (done.length / $scope.history.tasks.length) * 100;
    }

    var drake = dragularService($element.children(), {
      scope: $scope
    });

    $scope.$on('dragulardrop', function(e, element, column) {
      e.stopPropagation();
      var status = $(column).attr('data-status');
      var id = $(element).children().first().attr('data-card-id');
      setTimeout(function() {
        $http.put('history/'+id+'/status', {status: status}).then(
          function(res) {
            if (!res.data) {
              $scope.errorAlert('Fail to move history');
            }
          }
        );
      }, 200);
    });

    $scope.$watch('history.deadline', function() {
      if ($scope.history.deadline) {
        $scope.history.deadline = $filter('date')(new Date($scope.history.deadline), 'yyyy/MM/dd hh:mm', '-0200');
      }
    })

    $scope.successAlert = function(msg) {
        $('.top-right').notify({message: {text: msg}, type: 'success'}).show();
    }

    $scope.errorAlert = function(msg) {
        $('.top-right').notify({message: {text: msg}, type: 'danger'}).show();
    }

    $scope.enableEdit = function() {
        $scope.enProjEdit = !$scope.enProjEdit;
    }

    // Called on anguar init
    $scope.init = function() {
        dragularService('.containerVertical');
        // Set empty projects
        $scope.projects = {};
        // Get stored projects
        $http.get('project/get').then(
            function(projects) {
                // set results to projects object
                $scope.projects = projects.data;
            },
            function(err) {
                // log if had error
                console.log(err);
            }
        );
    }

    // Shows modal to select a project
    $scope.changeProject = function () {
        $('#projectModal').modal('show');
    }

    // Find all histories from a project
    $scope.selectProject = function() {
        if ($('#projectDropdown :selected').text())
            $scope.histories = [];
            // Set the text from select to project label
            $scope.projectId = $scope.select.id;
            $scope.projectName = $scope.select.label
        
        // Send http get to projects controller requesting histories
        $http.get('project/'+$scope.select.id+'/histories').then(
            function(histories) {
              // set histories to scope
              console.log(histories.data)
              $scope.histories['pending'] = (histories.data.pending.length > 0) ? JSON.parse(histories.data.pending) : {};
              $scope.histories['started'] = (histories.data.started.length > 0) ? JSON.parse(histories.data.started) : {};
              $scope.histories['delivered'] = (histories.data.delivered.length > 0) ? JSON.parse(histories.data.delivered) : {};
              console.log($scope.histories);
              // Hides modal
              $('#projectModal').modal('hide');
            },
            function(err) {
                // Log if had error
                console.log(err);
            }
        )
    }

    // Closes the projects selection modal and show a modal to insert the name for a new project
    $scope.newProject = function() {
        $('#projectModal').modal('hide');
        $('#newProjectModal').modal('show');
    }

    // Store new project in DB
    $scope.saveNewProject = function() {
        // Send a post request to Projects#store
        $http.post('project/store', {name: $('#newProjectName').val()}).then(
        function(res){
            // Response if the projec#add successfully executed
            // Set fail message
            var message = 'The Project creation failed! ';
            if (res.data.project.id) {
                $scope.projects.push({id: res.data.project.id, label: res.data.project.name});
                // Set success message
                message = 'The Project was successfully created! ';
            }
            // Notify user
            $scope.successAlert(message);

            // toggle new and select project modal
            $('#projectModal').modal('show');
            $('#newProjectModal').modal('hide');
        },
        function(err) {
            // Log if had error
            $scope.errorAlert('The Project creation failed! ');
            console.log(err);
        });
    }

    $scope.updateProject = function(name) {
      $http.put('project/'+$scope.projectId+'/update', {name: name}).then(
        function(res) {
          if (res.data) {
            $scope.successAlert('Project successfully update');
            $scope.enableEdit();
            $scope.projects = $scope.projects.filter(
              function(project){
                if(project.id == $scope.projectId) {
                  return false
                }
                return true
              }
            );
            $scope.projects.push({id: $scope.projectId, label: name});
          } else {
            $scope.successAlert('Fail to update Project');
          }
        },
        function(res) {
            console.log(res);

        }
      );   
    }

    $scope.rmProject = function(selected)
    {
        // Confirm if user really wants to remove
        if (confirm('Are you shure to delete this item?')) {
            // Send delete call to api
            $http.delete('project/'+selected.id+'/destroy').then(
                function(res) {
                    // true == destroyed
                    if (res.data == true) {
                        // remove deleted items from projects object
                        $scope.projects = $scope.projects.filter(
                            function(project){
                                if(project.id == selected.id) {
                                    return false
                                }
                                return true
                            }
                        );
                        // Clear data from selected project  
                        $scope.projectName = "Select your project";
                        $scope.histories = {};
                        // Notify user
                        $scope.successAlert('Project successfully removed');
                    } else {
                        // Notify user
                        $scope.errorAlert('Fail to remove Project');
                    }
                },
                function(err) {
                    // Notify user
                    $scope.errorAlert('Fail to remove Project');
                    // log if had error
                    console.log(err);
                }
            );
        };
    }

    $scope.newHistory = function() {
      $scope.update = false;
      $scope.history = {tasks: []};
      $('#newHistoryModal').modal('show');
    }

    $scope.addTask = function() {
      $scope.history.tasks.push({});
      $scope.percent();
    }

    $scope.rmTask = function(i) {
      $scope.history.tasks.splice(i, 1);
      $scope.percent();
    }

    $scope.saveHistory = function() {
      $scope.percent();
      if (!$scope.update) {
        $http.post('history/store', {history: $scope.history, tasks: $scope.history.tasks, project_id: $scope.projectId}).then(
          function(res) {
            if (res.data.id) {
              $scope.histories.pending.push(res.data);
              $('#newHistoryModal').modal('hide');
              $scope.successAlert('History successfully created');
            } else {
              console.log(res.data)
            }
          },
          function(err) {
            $scope.errorAlert('Fail to create new history');
          }
        );
      } else {
        $http.put('history/'+$scope.history.id+'/update', {history: $scope.history}).then(
          function(res) {
            if (res.data.id) {
              var i = $scope.histories[res.data.status].findIndex(function(el, i, h) {
                if (el.id == $scope.history.id) {
                  return true;
                }
                return false;
              });
              $scope.histories[res.data.status][i] = res.data;
              $('#newHistoryModal').modal('hide');
              $scope.successAlert('History successfully update');
            } else {
              console.log(res.data);
            }
          },
          function(err) {
            $scope.errorAlert('Fail to create new history');
          }
        );
      }
    }

    $scope.rmHistory = function(id, i, status) {
      $http.delete('history/'+id+'/destroy').then(
        function(res) {
          if (res.data) {
            $scope.histories[status].splice(i, 1);
          } else {
            console.log(res);
          }
        },
        function(err) {
          console.log(err);
        }
      );
    }

    $scope.changeHistory = function(i, status) {
      $scope.update = true;
      $scope.history = $scope.histories[status][i];

      setTimeout(function(){
        $('#requester_id').val($scope.histories[status][i].requester_id);
        $('#points').val($scope.histories[status][i].points);
      }, 100);

      $('#newHistoryModal').modal('show');
      $scope.percent();
    }

    // Fix to datetimepicker
    $scope.deadlineBlur = function() {
      $scope.history.deadline = $('#deadline').val();
    }

    $scope.taskDone = function(id) {
      $scope.percent();
      $http.put('task/'+id+'/done').then(
        function(res) {
          if (res.data == true) {
            $scope.successAlert('Task successfully done / undone');
          } else {
            $scope.errorAlert('Fail when done / undone task');
          }
        },
        function(err) {
          $scope.successAlert('Fail when done / undone task');
        }
      );
    }

    $scope.finish = function(id) {
      $http.put('history/'+id+'/finish').then(
        function(res) {
          if (res.data == true) {
            $scope.successAlert('History successfully finished');
            $('#newHistoryModal').modal('hide');
          } else {
            $scope.errorAlert('Fail to finish History');
          }
        },
        function(){
          $scope.errorAlert('Fail to finish History');
        }
      );
    }
}]);