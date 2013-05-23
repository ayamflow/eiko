'use strict';

angular.module('myApp.directives')
.directive('concept', ['$timeout', function($timeout) {
    return {
        link: function(scope, element, attr) {

            $timeout(init);

            function init() {
              var $dots = element.find('.thumbs li');

                scope.conceptTl = new TimelineMax();

                scope.conceptTl.add(TweenMax.from(element.find('.slide').eq(0).find('.content'), 0.4, {alpha: 0, left: -80, ease: Cubic.easeInOut}), 0);
                for(var i=$dots.length; i>=0 ; i--) {
                  scope.conceptTl.add(TweenMax.from($dots.eq(i), 0.3, {alpha: 0, position: 'relative', right: -80, ease: Cubic.easeInOut}), 0.2 + i*0.08);
                }

                scope.conceptTl.gotoAndStop(0);
            }
        }
    };
}]);