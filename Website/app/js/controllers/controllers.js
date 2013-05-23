'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
controller('EikoController', [ '$scope', function($scope) {
    $scope.slideDiaporama = [1, 2, 3, 4, 5];

    $scope.fragments = [];
    for(var i=1; i <= 18; i++) $scope.fragments.push(i);
}]);