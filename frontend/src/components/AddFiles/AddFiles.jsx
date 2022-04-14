import React, { useEffect, useState } from "react";
import Header from "../Header/Header";
import './addfile.css'
import {Link} from "react-router-dom";




function AddFiles() {

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
        <div className="container preview mt-3">
            <div className="row">
                <div className="col-md-3">
                    <div className="sidebar p-3">

                    <Link className="link p-3 mb-3" to="/dashboard-admins">
                            Admins
                        </Link>
                        <Link className="link p-3 mb-3" to="/dashboard-add-files">
                            Add Files
                        </Link>
                        <Link className="link p-3 mb-3" to="/dashboard-public-files">
                            Public Files
                        </Link>
                        <Link className="link p-3 mb-3" to="/dashboard-private-files">
                            Private Files
                        </Link>
                        <Link className="link p-3 mb-3" to="/dashboard-reported-files">
                            Reported Files
                        </Link>
                        <Link className="link p-3 mb-3" to="/dashboard-reported-users">
                            Reported Users
                        </Link>
                        <Link className="link p-3 mb-3" to="/dashboard-blacklisted-users">
                            Blacklisted Users
                        </Link>
                        <button className="btn btn-primary btn-large ms-3" >
                            Disconnect
                        </button>
                    </div>
                </div>
                <div className="col-md-9">
                    <div className="row mb-3">
                        <h3>Add Files</h3>
                    </div>
                    <div className="row">
                    <form className="row g-3">
                        <div className="col-md-12">
                            <label  className="form-label">Name</label>
                            <input type="text" className="form-control" id="inputEmail4"/>
                        </div>
                        <div className="col-md-12">
                            <label className="form-label">Description</label>
                            <textarea className="form-control" id="exampleFormControlTextarea1" rows="3"></textarea>
                        </div>
                        <div className="col-12">
                            <label  className="form-label">Upload File</label>
                            <input type="file" className="form-control" id="inputAddress" placeholder="Description"/>
                        </div>
                        <div className="col-12">
                            <div className="form-check form-switch">
                            <input className="form-check-input" type="checkbox" />
                             <label className="form-check-label" >Make Private</label>
                             </div>
                        </div>
                        <div className="col-12">
                            <button type="submit" className="btn btn-primary">Add File</button>
                        </div>
                    </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
  );
}

export default AddFiles;
