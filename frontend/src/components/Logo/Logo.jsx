import React from "react";
import "./css/Logo.css";
import { Link } from 'react-router-dom';

function Logo(props) {
  let img;
  if (props.dark) {
    img = "image-dark-theme/logo.svg";
  } else {
    img = "image-light-theme/logo.svg";
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
