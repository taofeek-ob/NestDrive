import React, { useEffect, useState } from "react";
import Header from "../Header/Header";
import Iframe from "react-iframe";
import {Link} from "react-router-dom";




function FilePreview() {

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
    document.querySelector(".preview").style.paddingTop = `${
      headerHeight + 20
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

 

  return (
    <div>
      <Header
        isdarkThemeActive={darkThemeActive}
      />

      <div className="container mt-5 preview">
          <div className="row">
              <div className="col-12 col-md-6">
                <h3>This is the file Name</h3>
                <small>created by <Link to="/profile">0x9F6Dd51f7a18Ce5D6FaFF9e5d3e5764Cca61cC44</Link></small>
                <br/><br/>
                <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>
                <p className="card-text"><small className="text-muted">Uploaded on  13th April 2022</small></p>
                <img  src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&amp;data=google.com"/>
                <div  className="mt-2">
                    <button className="btn btn-small btn-primary me-1">Share File</button>
                    <button className="btn btn-small btn-warning me-1">Report File</button>
                    <button className="btn btn-small btn-success">Download File</button>
                </div>
              </div>
              <div className="col-12 col-md-6">
              <Iframe url="https://www.jpmorganchase.com/content/dam/jpmc/jpmorgan-chase-and-co/investor-relations/documents/how-we-do-business.pd"
                width="100%"f
                height="600px"
                id="myId"
                className="myClassname"
                display="initial"
                position="relative"/>
              </div>
          </div>
      </div>
      </div>
  );
}

export default FilePreview;
