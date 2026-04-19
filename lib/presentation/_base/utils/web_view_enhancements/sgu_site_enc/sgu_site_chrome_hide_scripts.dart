/// Ранний инжект + повтор на [onLoadStop] (SPA / смена DOM). Идемпотентно.
class SguSiteChromeHideScripts {
  SguSiteChromeHideScripts._();

  static const String header = r'''
(function(){try{if(document.querySelector('style[data-sgu-schedule="header"]'))return;var s=document.createElement('style');s.setAttribute('data-sgu-schedule','header');s.innerHTML='header,.site-header,.page-header,#header,.navbar,.header-region,.region-header{display:none!important;}';(document.documentElement||document.head||document.body).appendChild(s);}catch(e){}})();
''';

  static const String footer = r'''
(function(){try{if(document.querySelector('style[data-sgu-schedule="footer"]'))return;var s=document.createElement('style');s.setAttribute('data-sgu-schedule','footer');s.innerHTML='footer,.site-footer,.page-footer,#footer,.footer-region,.region-footer{display:none!important;}';(document.documentElement||document.head||document.body).appendChild(s);}catch(e){}})();
''';
}
