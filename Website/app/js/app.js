'use strict';

// Declare app level module which depends on filters, and services
var hkiApp = angular.module('myApp', ['myApp.controllers', 'myApp.utils', 'myApp.filters', 'myApp.directives', "myApp.factories"]);
hkiApp.run(['$rootScope', '$http', '$timeout', function($rootScope, $http, startRouting, $timeout) {
        $rootScope.scrollbarSize = -1;
  }]);
angular.module('myApp.directives', []);