import React, { useState, useEffect } from 'react';
import Carousel from 'react-bootstrap/Carousel';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css'; // Assuming the CSS file is in the same directory or adjust path accordingly
import akcio1 from './kep/akcio1.png';
import kep1 from './kep/kep1.jpg';
import kep2 from './kep/kep2.jpg';
import kep3 from './kep/kep3.jpg';

function App() {
  const [showScrollButton, setShowScrollButton] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 20) {
        setShowScrollButton(true);
      } else {
        setShowScrollButton(false);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <>
      <button
        onClick={scrollToTop}
        id="felfele-gomb"
        title="Feljebb"
        style={{
          display: showScrollButton ? 'block' : 'none',
          fontSize: '150%',
        }}
      >
        👆
      </button>
      <ul>
        <div>
          <a href="index.html" className="klink" style={{ backgroundColor: '#00FFFF' }}>
            Tovább a webshopba
          </a>
          <a href="kosar.html" className="klink" style={{ backgroundColor: '#00FFFF' }}>
            Kosár
          </a>
          <a href="reg.html" className="klink" style={{ backgroundColor: '#00FFFF' }}>
            Regisztráció
          </a>
          <a href="bej.html" className="klink" style={{ backgroundColor: '#00FFFF' }}>
            Bejelentkezés
          </a>
          <a href="rolunk.html" className="klink" style={{ backgroundColor: '#00FFFF' }}>
            Rólunk
          </a>
        </div>
      </ul>
      <p id="kezdolapu">Üdvözlünk a Kisállat Webshop webáruházban!</p>
      <Carousel id="demo" className="carousel slide">
        <Carousel.Item>
          <img
            className="d-block w-100"
            src={akcio1}
            alt="akcio"
          />
          <Carousel.Caption className="bg-dark bg-opacity-50 rounded-pill">
            <h3>Jelenlegi szuper akciónk!</h3>
            <p>
              <a href="tap.html#t12" style={{ textDecoration: 'none', color: 'white' }}>
                Royal Canin Veterinary Canine Early Renal
              </a>
            </p>
          </Carousel.Caption>
        </Carousel.Item>
        <Carousel.Item>
          <img
            className="d-block w-100"
            src={kep1}
            alt=""
          />
        </Carousel.Item>
        <Carousel.Item>
          <img
            className="d-block w-100"
            src={kep2}
            alt=""
          />
        </Carousel.Item>
        <Carousel.Item>
          <img
            className="d-block w-100"
            src={kep3}
            alt=""
          />
        </Carousel.Item>
      </Carousel>
      <p></p>
      <div className="footer">
        <p style={{ color: 'white' }}>
          A képek a <a target="_blank" href="http://www.zooplus.hu">zooplus</a> weboldalról származnak.
        </p>
      </div>
    </>
  );
}

export default App;