// initialize angular module
var app = angular.module('miniTrello', []);

// initialize angular controller
app.controller('MainCtrl', ['$scope', '$http', function($scope, $http) {
    // Defining default label when no project was selected
    $scope.projectName = "Select your project"

    // Shows modal to select a project
    $scope.changeProject = function () {
        $('#projectModal').modal('show');
    }

    // Find all histories from a project
    $scope.selectProject = function() {
        if ($('#projectDropdown :selected').text())
            // Set the text from select to project label
            $scope.projectName = $('#projectDropdown :selected').text();
        
        // Send http get to projects controller requesting histories
        $http.get('project/'+$scope.project+'/histories').then(
            function(histories) {
                // set histories to scope
                $scope.histories = histories.data;
                // Hides modal
                $('#projectModal').modal('hide');
            },
            function(err) {
                // Log if error
                console.log(err);
            }
        )
    }
}]);