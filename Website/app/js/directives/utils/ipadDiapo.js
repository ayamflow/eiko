'use strict';

angular.module('myApp.directives')
.directive('ipadDiapo', ['$timeout', function($timeout) {
    return {
        link: function(scope, element, attr) {
            var $inner, $outer, baseWidth, number, $slides, position = 0, maxScroll, currentSlide = 0, $leftArrow, $rightArrow, tweenScroll = { left: 0};

            $timeout(init);

            scope.$on("$destroy", destroy);
            $(window).bind('resize', resize);

            function init() {
                $outer = element.find('.' + attr['outer']);
                $inner = element.find('.' + attr['inner']);
                $slides = element.find('.' + attr['slide']);

                number = $slides.length;

                resize();

                $leftArrow = element.find('.arrow.left');
                $rightArrow = element.find('.arrow:not(.left)');
                $leftArrow.on('click', changeSlide)
                $rightArrow.on('click', changeSlide);
            }

            function resize() {
                baseWidth = $slides.eq(0).width();
                maxScroll = baseWidth * number;
                $inner.width(maxScroll);
                 TweenMax.to($outer, 0.8, {scrollLeft: currentSlide * baseWidth, ease: Expo.easeInOut});
            }

            function changeSlide(e) {
                currentSlide += $(e.currentTarget).hasClass('left') ? -1 : 1;

                if(currentSlide < 0) currentSlide = number - 1;
                if(currentSlide >= number) currentSlide = 0;

                TweenMax.to($outer, 0.8, {scrollLeft: currentSlide * baseWidth, ease: Power2.easeInOut});
            }

            function destroy() {
                $(window).off('resize', resize);
                $leftArrow.off('click', changeSlide);
                $rightArrow.off('click', changeSlide);
            }
        }
    };
}]);