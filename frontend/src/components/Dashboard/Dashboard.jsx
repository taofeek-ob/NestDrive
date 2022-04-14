import React, { useEffect, useState } from "react";
import Header from "../Header/Header";
import './dashboard.css'
import {Link} from "react-router-dom";




function Dashboard() {

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
        <div className="container preview mt-4">
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
                        <h3>Hi, 0x9F6Dd51f7a18Ce5D6FaFF9e5d3e5764Cca61cC44</h3>
                    </div>
                    <div className="row">
                        <div className="col-md-6">
                            <div className="card">
                                <div className="card-body">
                                    <h4 className="card-title">Public Files</h4>
                                    <p>No of public files you have created</p>
                                    <h4 id="counttruckdrivers" className="text-dark font-weight-bold mb-2">64</h4>
                                </div>
                            </div>
                        </div>
                        <div className="col-md-6">
                            <div className="card">
                                <div className="card-body">
                                    <h4 className="card-title">Private Files</h4>
                                    <p>No of private files you have created</p>
                                    <h4 id="counttruckdrivers" className="text-dark font-weight-bold mb-2">64</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
  );
}

export default Dashboard;
