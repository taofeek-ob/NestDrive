import React from "react";
import "./css/Hero.css";
import Picture from "../Picture/Picture";
import Article from "../Article/Article";
import Form from "../Form/Form";

export default function Hero(props) {
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
          <button className="button">Get Started</button>
        </div>
      </article>
    </div>
  );
}
