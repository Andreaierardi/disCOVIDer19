 shinyjs::runjs('
        var el2 = document.querySelector(".skin-red");
        el2.className = "skin-red sidebar-mini";
        ')
  
  shinyjs::addClass(selector = "body", class = "sidebar-collapse")
  
  waiter::waiter_hide()