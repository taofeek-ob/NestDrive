import React from "react";
import './file.css'
import {Link} from 'react-router-dom';

function File(props) {
  let card;
  if (props.isdarkThemeActive) {

    card = "card mb-3 card-dark";
    } else {
   card = "card mb-3 ";
    }

    let myArray = ["folders/first1.jpeg", "folders/first2.jpeg", "folders/first3.jpeg"];

    let imageSrc = myArray[Math.floor(Math.random()*myArray.length)];

  
 

  return (
    <div className="col-12 col-md-6">
      <div className={card}>
            <div className="row g-0">
              <div className="col-md-4">
                <img src={imageSrc} className="img-fluid rounded-start" alt="..."/>
              </div>
              <div className="col-md-8">
                <div className="card-body">
                  <h5 className="card-title">Card title</h5>
                  <p className="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                  <p className="card-text"><small className="text-muted">Uploaded on  13th April 2022</small></p>
                  <Link className="btn btn-small btn-primary" to="/file">View File</Link>
                </div>
              </div>
            </div>
        </div>
    </div>
    
      
    
  );
}

export default File;
