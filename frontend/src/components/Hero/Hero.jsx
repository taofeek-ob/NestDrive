import React from "react";
import "./css/Hero.css";
import Picture from "../Picture/Picture";
import Article from "../Article/Article";
import Form from "../Form/Form";
import  { useState, useContext, useEffect } from "react";
import { ConnectContext } from "../../context/ConnectContext";
import { Link } from "react-router-dom";





export default function Hero(props) {
   const { currentAccount, connectWallet } = useContext(ConnectContext);

  const[ shortenedAddress, setShortenedAddress ] = useState("");

  useEffect(()=>{
    setShortenedAddress(`${currentAccount.toString().slice(0, 5)}...${currentAccount.toString().slice(currentAccount.length - 4)}`)  

  }, []);

  return (
    <div
      className={
        props.isdarkThemeActive
          ? "Hero-wrapper Hero-wrapper-dark"
          : "Hero-wrapper"
      }
    >
      <article className="Hero">
        <Picture
          isdarkThemeActive={props.isdarkThemeActive}
          imgName="files-store-illustration.svg"
        />
        <div>
          <Article
            section="hero"
            headingType="heading"
            isdarkThemeActive={props.isdarkThemeActive}
            heading="NestDrive, Your Decentralized Online Library"
            paragraph={[
              "Store your public and private books, audiobooks, articles on the blockchain. Access them wherever you need, share and collaborate with friends, family and co-workers.",
            ]}
          />
          {!currentAccount ? (
            <button className="button" onClick={connectWallet}>
              Connect Wallet
            </button>
          ) : (
            <span className="button">
              Signed in as: <Link to="/dashboard">{shortenedAddress}</Link>
            </span>
          )}
          
        </div>
      </article>
    </div>
  );
}
