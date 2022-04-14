<<<<<<< HEAD
import React, { useState, useContext, useEffect } from "react";
import "./css/Nav.css";
import { ConnectContext } from "../../context/ConnectContext";
import { Link } from "react-router-dom";
=======
import React, { useState } from "react";
import "./css/Nav.css";
>>>>>>> b5556bd87515246098b76df017cc9f0478993c56

function Nav(props) {
  let signInClass;
  let [navItemsClass, setNavItemsClass] = useState("nav-items");
  if (props.dark) {
    signInClass = "nav-item nav-item-active nav-item-active-dark";
  } else {
    signInClass = "nav-item nav-item-active";
  }

<<<<<<< HEAD
  const { currentAccount, connectWallet } = useContext(ConnectContext);

  const[ shortenedAddress, setShortenedAddress ] = useState("");

  useEffect(()=>{
    setShortenedAddress(`${currentAccount.toString().slice(0, 5)}...${currentAccount.toString().slice(currentAccount.length - 4)}`)  

  }, []);
  
  


=======
>>>>>>> b5556bd87515246098b76df017cc9f0478993c56
  function toggle() {
    const AnimatedBtnTop = document.querySelector(".AnimatedBtn-Top");
    const AnimatedBtnMiddle = document.querySelector(".AnimatedBtn-Middle");
    const AnimatedBtnBottom = document.querySelector(".AnimatedBtn-Bottom");
    AnimatedBtnTop.classList.toggle("AnimatedBtn-TopClick");
    AnimatedBtnMiddle.classList.toggle("AnimatedBtn-MiddleClick");
    AnimatedBtnBottom.classList.toggle("AnimatedBtn-BottomClick");
    navItemsClass === "nav-items"
      ? setNavItemsClass("nav-items nav-items-active")
      : setNavItemsClass("nav-items");
  }

  return (
    <nav className="nav">
      <div className={navItemsClass}>
<<<<<<< HEAD
        <Link className="nav-item"  to="/public-files">
          Public Files
        </Link>
        {!currentAccount ?
                    <a className="nav-item"
                    onClick={connectWallet}>Connect Wallet</a>
                :(
                    <span className="nav-item">
                    Signed in as: <Link to="/dashboard">{shortenedAddress}</Link>
                    </span>
                )
                }
=======
        <a className="nav-item" href="#">
          Feature
        </a>
        <a className="nav-item" href="#">
          Team
        </a>
        <a className={signInClass} href="#">
          Sign In
        </a>
>>>>>>> b5556bd87515246098b76df017cc9f0478993c56
      </div>
      <div className="AnimatedBtn">
        <span className={"AnimatedBtn-Top"}></span>
        <span className="AnimatedBtn-Middle"></span>
        <span className="AnimatedBtn-Bottom"></span>
        <div className="AnimatedBtn-Cover" onClick={toggle}></div>
      </div>
    </nav>
  );
}

export default Nav;
