;(function insertArticleToc() {
  var e = document.querySelector("article.content");
  var t = e.querySelector("h2");
  var r = e.querySelectorAll("h2, h3,h4");
  var m = ['<ul>'];
  var ts = [];
  var isHome = /\/$/.test(window.location.pathname) || /\/index.html$/.test(window.location.pathname);
  e.innerHTML = e.innerHTML.replace('<\\br>','\\');
  r.forEach(function(i){
    if(!i.childElementCount){
      ts = [' <a href="#'+ i.id +'">', '</a>'];
      i.tagName==="H4" || m.push('<li>'+ts.join(i.innerHTML)+'</li>');
      i.innerHTML += ts.join('#');
    }
  })
  m.push('</ul>');
  if (t  && r.length >= 2 && !isHome) {
      var c = document.createElement("div");
      c.setAttribute("class", "article-toc"),
      c.innerHTML = '<h3>目录</h3>'+m.join('\n'),
      e.insertBefore(c, t)
  }
})();