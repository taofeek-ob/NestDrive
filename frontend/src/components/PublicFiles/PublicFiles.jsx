import React, { useEffect, useState } from "react";
import Header from "../Header/Header";
import SearchFiles from "../SearchFiles/SearchFiles";
import File from "../File/File";


function PublicFiles() {

  let [darkThemeActive, setDarkThemeActive] = useState(false);

  function switchActiveTheme() {
    if (darkThemeActive) {
      setDarkThemeActive(false);
      document.querySelector("#root").style.backgroundColor = "white";
    } else {
      setDarkThemeActive(true);
      document.querySelector("#root").style.backgroundColor = "#1C2431";
    }
  }

  useEffect(() => {
    let headerFixedContainer = document.querySelector(".header-fixed");
    let headerHeight = headerFixedContainer.clientHeight;
    document.querySelector(".form").style.paddingTop = `${
      headerHeight + 40
    }px`;

    let lastScrolled = 0;

    window.addEventListener("scroll", () => {
      let scrolled = document.documentElement.scrollTop;
      if (scrolled > lastScrolled) {
        headerFixedContainer.style.top = `-${headerHeight + 40}px`;
      } else {
        headerFixedContainer.style.top = "0";
      }
      lastScrolled = scrolled;
    });
  });

  const children = [];  
  for(let i = 0;i < 25;i++) {
    children.push(<File isdarkThemeActive={darkThemeActive}/>);
  }

  return (
    <div>
      <Header
        isdarkThemeActive={darkThemeActive}
        switchActiveTheme={switchActiveTheme}
      />

      <SearchFiles isdarkThemeActive={darkThemeActive}/>
      
      <div className="container mt-5">
      <div className="row">
      
      {children}
        
          

      </div>
    </div>
    </div>
  );
}

export default PublicFiles;
