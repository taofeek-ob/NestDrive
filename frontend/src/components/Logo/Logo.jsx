import React from "react";
import "./css/Logo.css";
import { Link } from 'react-router-dom';

function Logo(props) {
  let img;
  if (props.dark) {
    img = "images/logo.png";
  } else {
    img = "images/logo.png";
  }

  return (
    <picture className="logo">
      <Link to="/">
      <img src={img} alt="logo of website" /> <span className="brand"> NestDrive</span>
        
      </Link>
    </picture>
  );
}

export default Logo;
