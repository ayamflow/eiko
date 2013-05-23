'use strict';

angular.module('myApp.directives')
.directive('home', ['$timeout', function($timeout) {
    return {
        link: function(scope, element, attr) {


            $timeout(init);

            function init() {
                var $imgs = element.find('img');
                var $links = $('header').find('li');
                var $fragments = element.find('.fragments li');

                scope.homeTl = new TimelineMax();
                scope.homeTl.addCallback(function() {
                    $('header').attr('style', '');
                }, 1.3);

                scope.homeTl.add(TweenMax.from($('header'), 0.4, {alpha: 0, top: 0, ease: Cubic.easeInOut}), 0);

                for(var i=0; i < $links.length; i++) {
                    scope.homeTl.add(TweenMax.from($links.eq(i), 0.4, {alpha: 0, left: -15, ease: Cubic.easeInOut}), 0.2 + i*0.1);
                }
                for(var i=0; i < $fragments.length; i++) {
                    scope.homeTl.add(TweenMax.from($fragments.eq(i), 0.2, {alpha: 0, scaleX: 4, scaleY: 4, ease: Cubic.easeInOut}), 0.2 + i*0.04);
                }
                for(i=0; i < $imgs.length; i++) {
                    scope.homeTl.add(TweenMax.from($imgs.eq(i), 0.8, { position: 'relative', alpha: 0, bottom: -40, ease: Cubic.easeInOut}), 0.3 + 0.1*i);
                }
                scope.homeTl.addCallback(function() {
                    scope.$broadcast('$home.ready');
                }, 1.3);

                scope.homeTl.gotoAndStop(0);
            }
        }
    };
}]);