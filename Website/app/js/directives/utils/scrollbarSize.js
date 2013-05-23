'use strict';

/*
*   This directive calculates the width of the scrollbar (approximately 15px, can vary depending on the browser).
*   When done, the div it uses is removed, and the value is stored in the $rootScope for later use.
*   See the isotope directive for use.
*/

angular.module('myApp.directives')
.directive('scrollbarSize', [ '$rootScope', function($rootScope) {
    return function(scope, elem, attr) {
        if($rootScope.scrollbarSize != -1) return;
        if(navigator.userAgent.indexOf('WebKit') == -1) $rootScope.scrollbarSize = 0;
        else {
            $rootScope.scrollbarSize = elem[0].offsetWidth - elem[0].clientWidth;
            elem[0].parentNode.removeChild(elem[0]);
        }
    };
}]);