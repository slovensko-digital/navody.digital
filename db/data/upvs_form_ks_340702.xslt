<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:ns="http://www.w3.org/TR/REC-html40"
  xmlns:e="http://schemas.gov.sk/form/00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk/1.53"><xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="utf-8"/><!-- GENERATED --><xsl:template match="/"><xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text><html lang="sk" class="app-sign"><head><title>Form</title><meta charset="UTF-8"/><!-- eGov css --><style type="text/css"><![CDATA[
  .form-group {
  transition: all 0.25s ease;
}

.link-back {
  border: none;
  background-color: transparent;
}

/*body {
  MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  
} */

.button {
  margin: 0.5em 0.5em 0.5em 0;
}

.change-button {
  -webkit-appearance: none;
  border: none;
  text-decoration: underline;
  background-color: transparent;
  cursor: pointer;
}

.grid-row:after,#content:after,.notice:after,.panel:after,fieldset:after,.form-section:after,.form-group:after,.breadcrumbs ol:after {
  content: "";
  display: block;
  clear: both;
}

#content {
  max-width: 960px;
  margin: 0 15px;
}

@media (min-width: 641px) {
  #content {
    margin: 0 30px;
  }
}

@media (min-width: 1020px) {
  #content {
    margin: 0 auto;
  }
}

.grid-row {
  margin: 0 -15px;
}

.grid-row:after,#content:after,.notice:after,.panel:after,fieldset:after,.form-section:after,.form-group:after,.breadcrumbs ol:after {
  content: "";
  display: block;
  clear: both;
}

.grid-row:after,#content:after,.notice:after,.panel:after,fieldset:after,.form-section:after,.form-group:after,.breadcrumbs ol:after {
  content: "";
  display: block;
  clear: both;
}

.grid-row:after,#content:after,.notice:after,.panel:after,fieldset:after,.form-section:after,.form-group:after,.breadcrumbs ol:after {
  content: "";
  display: block;
  clear: both;
}

#content {
  max-width: 960px;
  margin: 0 15px;
}

@media (min-width: 641px) {
  #content {
    margin: 0 30px;
  }
}

@media (min-width: 1020px) {
  #content {
    margin: 0 auto;
  }
}

.grid-row {
  margin: 0 -15px;
}

.grid-row:after,#content:after,.notice:after,.panel:after,fieldset:after,.form-section:after,.form-group:after,.breadcrumbs ol:after {
  content: "";
  display: block;
  clear: both;
}

.grid-row:after,#content:after,.notice:after,.panel:after,fieldset:after,.form-section:after,.form-group:after,.breadcrumbs ol:after {
  content: "";
  display: block;
  clear: both;
}

.visually-hidden,.visuallyhidden {
  position: absolute;
  overflow: hidden;
  clip: rect(0 0 0 0);
  height: 1px;
  width: 1px;
  margin: -1px;
  padding: 0;
  border: 0;
}

div,span,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,details,embed,figure,figcaption,footer,header,hgroup,menu,nav,output,ruby,section,summary,time,mark {
  border: none;
  margin: 0;
  padding: 0;
}

h1,h2,h3,h4,h5,h6,p,blockquote,pre,small,strike,strong,sub,sup,tt,var,b,u,i,center,input,textarea,table,caption,tbody,tfoot,thead,tr,th,td {
  font-size: inherit;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: inherit;
  */
  line-height: inherit;
  font-weight: normal;
}

abbr[title],acronym[title] {
  text-decoration: none;
}

legend {
  box-sizing: border-box;
  max-width: 100%;
  display: table;
}

#content {
  padding-bottom: 30px;
  outline: none;
}

@media (min-width: 769px) {
  #content {
    padding-bottom: 90px;
  }
}

.column-quarter,.column-one-quarter {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-quarter,.column-one-quarter {
    float: left;
    width: 25%;
  }
}

.column-half,.column-one-half {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-half,.column-one-half {
    float: left;
    width: 50%;
  }
}

.column-third,.column-one-third {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-third,.column-one-third {
    float: left;
    width: 33.33333%;
  }
}

.column-two-thirds {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-two-thirds {
    float: left;
    width: 66.66667%;
  }
}

.column-full {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-full {
    float: left;
    width: 100%;
  }
}

main {
  font-family: "Source Sans Pro", "Arial", sans-serif;
  font-weight: 400;
  text-transform: none;
  font-size: 18px;
  line-height: 1.2;
  -webkit-font-smoothing: antialiased;
}

@media (min-width: 641px) {
  main {
    font-size: 20px;
    line-height: 1.25;
  }
}

label{
  font-size: 18px;
  line-height: 1.2;
}

@media (min-width: 641px) {
  label {
    font-size: 20px;
    line-height: 1.25;
  }
}

/* backup
main {
  font-family: "Source Sans Pro",sans-serif;
  font-weight: 400;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
  -webkit-font-smoothing: antialiased;
}

@media (min-width: 641px) {
  main {
    font-size: 19px;
    line-height: 1.31579;
  }
}

*/

.font-xxlarge {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 53px;
  line-height: 1.03774;
}

@media (min-width: 641px) {
  .font-xxlarge {
    font-size: 80px;
    line-height: 1;
  }
}

.font-xlarge {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 32px;
  line-height: 1.09375;
}

@media (min-width: 641px) {
  .font-xlarge {
    font-size: 48px;
    line-height: 1.04167;
  }
}

.font-large {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 24px;
  line-height: 1.04167;
}

@media (min-width: 641px) {
  .font-large {
    font-size: 36px;
    line-height: 1.11111;
  }
}

.font-medium {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 18px;
  line-height: 1.2;
}

@media (min-width: 641px) {
  .font-medium {
    font-size: 24px;
    line-height: 1.25;
  }
}

.font-small {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
}

@media (min-width: 641px) {
  .font-small {
    font-size: 19px;
    line-height: 1.31579;
  }
}

.font-xsmall {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
}

@media (min-width: 641px) {
  .font-xsmall {
    font-size: 16px;
    line-height: 1.25;
  }
}

.bold-xxlarge {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 53px;
  line-height: 1.03774;
}

@media (min-width: 641px) {
  .bold-xxlarge {
    font-size: 80px;
    line-height: 1;
  }
}

.bold-xlarge {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 32px;
  line-height: 1.09375;
}

@media (min-width: 641px) {
  .bold-xlarge {
    font-size: 48px;
    line-height: 1.04167;
  }
}

.bold-large {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 24px;
  line-height: 1.04167;
}

@media (min-width: 641px) {
  .bold-large {
    font-size: 36px;
    line-height: 1.11111;
  }
}

.bold-medium {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 18px;
  line-height: 1.2;
}

@media (min-width: 641px) {
  .bold-medium {
    font-size: 24px;
    line-height: 1.25;
  }
}

.bold-small {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
}

@media (min-width: 641px) {
  .bold-small {
    font-size: 19px;
    line-height: 1.31579;
  }
}

.bold-xsmall {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
}

@media (min-width: 641px) {
  .bold-xsmall {
    font-size: 16px;
    line-height: 1.25;
  }
}

.bold {
  font-weight: 700;
}

.heading-xlarge {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 32px;
  line-height: 1.09375;
  margin-top: .46875em;
  margin-bottom: .9375em;
}

@media (min-width: 641px) {
  .heading-xlarge {
    font-size: 48px;
    line-height: 1.04167;
  }
}

@media (min-width: 641px) {
  .heading-xlarge {
    margin-top: .625em;
    margin-bottom: 1.25em;
  }
}

.heading-xlarge .heading-secondary {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 20px;
  line-height: 1.11111;
  display: block;
  padding-top: 8px;
  padding-bottom: 7px;
  display: block;
  color: #6f777b;
}

@media (min-width: 641px) {
  .heading-xlarge .heading-secondary {
    font-size: 27px;
    line-height: 1.11111;
  }
}

@media (min-width: 641px) {
  .heading-xlarge .heading-secondary {
    padding-top: 4px;
    padding-bottom: 6px;
  }
}

.heading-large {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 24px;
  line-height: 1.04167;
  margin-top: 1.04167em;
  margin-bottom: .41667em;
}

@media (min-width: 641px) {
  .heading-large {
    font-size: 36px;
    line-height: 1.11111;
  }
}

@media (min-width: 641px) {
  .heading-large {
    margin-top: 1.25em;
    margin-bottom: .55556em;
  }
}

.heading-large .heading-secondary {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 18px;
  line-height: 1.2;
  display: block;
  padding-top: 9px;
  padding-bottom: 6px;
  display: block;
  color: #6f777b;
}

@media (min-width: 641px) {
  .heading-large .heading-secondary {
    font-size: 24px;
    line-height: 1.25;
  }
}

@media (min-width: 641px) {
  .heading-large .heading-secondary {
    padding-top: 6px;
    padding-bottom: 4px;
  }
}

.heading-medium {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 18px;
  line-height: 1.2;
  margin-top: 1.25em;
  margin-bottom: .5em;
}

@media (min-width: 641px) {
  .heading-medium {
    font-size: 24px;
    line-height: 1.25;
  }
}

@media (min-width: 641px) {
  .heading-medium {
    margin-top: 1.875em;
    margin-bottom: .83333em;
  }
}

.heading-small {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
  margin-top: .625em;
  margin-bottom: .3125em;
}

@media (min-width: 641px) {
  .heading-small {
    font-size: 19px;
    line-height: 1.31579;
  }
}

@media (min-width: 641px) {
  .heading-small {
    margin-top: 1.05263em;
  }
}

p,.body-text {
  margin-top: .3125em;
  margin-bottom: 1.25em;
}

@media (min-width: 641px) {
  p,.body-text {
    margin-top: .26316em;
    margin-bottom: 1.05263em;
  }
}

.body-text {
  display: block;
}

.lede {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 18px;
  line-height: 1.2;
}

@media (min-width: 641px) {
  .lede {
    font-size: 24px;
    line-height: 1.25;
  }
}

.text {
  max-width: 30em;
}

.text-secondary {
  color: #6f777b;
}

.link {
  color: #005ea5;
  text-decoration: underline;
}

.link:visited {
  color: #4c2c92;
}

.link:hover {
  color: #2b8cc4;
}

.link:active {
  color: #005ea5;
}

.link-back {
  display: -moz-inline-stack;
  display: inline-block;
  position: relative;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
  margin-top: 15px;
  margin-bottom: 15px;
  padding-left: 14px;
  color: #0b0c0c;
  text-decoration: none;
  border-bottom: 1px solid #0b0c0c;
}

@media (min-width: 641px) {
  .link-back {
    font-size: 16px;
    line-height: 1.25;
  }
}

.link-back:link,.link-back:visited,.link-back:hover,.link-back a.link-back:focus,.link-back:active {
  color: #0b0c0c;
}

.link-back::before {
  content: '';
  display: block;
  width: 0;
  height: 0;
  border-top: 5px solid transparent;
  border-right: 6px solid #0b0c0c;
  border-bottom: 5px solid transparent;
  position: absolute;
  left: 0;
  top: 50%;
  margin-top: -6px;
}

.code {
  color: #0b0c0c;
  background-color: #f8f8f8;
  text-shadow: 0 1px #fff;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', mon
  */ospace;
  font-size: 14px;
  direction: ltr;
  text-align: left;
  white-space: pre;
  word-spacing: normal;
  word-break: normal;
  line-height: 1.5;
  -moz-tab-size: 4;
  -o-tab-size: 4;
  tab-size: 4;
  -webkit-hyphens: none;
  -moz-hyphens: none;
  -ms-hyphens: none;
  hyphens: none;
  border: 1px solid #bfc1c3;
  padding: 4px 4px 2px;
}

hr {
  display: block;
  background: #bfc1c3;
  border: 0;
  height: 1px;
  margin-top: 30px;
  margin-bottom: 30px;
  padding: 0;
}

.notice {
  position: relative;
}

.notice .icon {
  position: absolute;
  left: 0;
  top: 50%;
  margin-top: -17px;
}

.notice strong {
  display: block;
  padding-left: 65px;
  margin-left: -15px;
}

.data {
  margin-top: .3125em;
  margin-bottom: 1.25em;
}

@media (min-width: 641px) {
  .data {
    margin-top: .26316em;
    margin-bottom: 1.05263em;
  }
}

.data-item {
  display: block;
  line-height: 1;
}

.button {
  background-color: #00823b;
  position: relative;
  display: -moz-inline-stack;
  display: inline-block;
  padding: .526315em .789473em .263157em;
  border: none;
  -webkit-border-radius: 0;
  -moz-border-radius: 0;
  border-radius: 0;
  outline: 1px solid transparent;
  outline-offset: -1px;
  -webkit-appearance: none;
  -webkit-box-shadow: 0 2px 0 #003618;
  -moz-box-shadow: 0 2px 0 #003618;
  box-shadow: 0 2px 0 #003618;
  font-size: 1em;
  line-height: 1.25;
  text-decoration: none;
  -webkit-font-smoothing: antialiased;
  cursor: pointer;
  color: #fff;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  vertical-align: top;
}

.button:visited {
  background-color: #00823b;
}

.button:hover,.button:focus {
  background-color: #00692f;
}

.button:active {
  top: 2px;
  -webkit-box-shadow: 0 0 0 #00823b;
  -moz-box-shadow: 0 0 0 #00823b;
  box-shadow: 0 0 0 #00823b;
}

.button.disabled,.button[disabled="disabled"],.button[disabled] {
  zoom: 1;
  filter: alpha(opacity=50);
  opacity: .5;
}

.button.disabled:hover,.button[disabled="disabled"]:hover,.button[disabled]:hover {
  cursor: default;
  background-color: #00823b;
}

.button.disabled:active,.button[disabled="disabled"]:active,.button[disabled]:active {
  top: 0;
  -webkit-box-shadow: 0 2px 0 #003618;
  -moz-box-shadow: 0 2px 0 #003618;
  box-shadow: 0 2px 0 #003618;
}

.button:link,.button:link:focus,.button:hover,.button:focus,.button:visited {
  color: #fff;
}

.button:before {
  content: "";
  height: 110%;
  width: 100%;
  display: block;
  background: transparent;
  position: absolute;
  top: 0;
  left: 0;
}

.button:active:before {
  top: -10%;
  height: 120%;
}

@media (max-width: 640px) {
  .button {
    width: 100%;
    text-align: center;
  }
}

.button::-moz-focus-inner {
  border: 0;
  padding: 0;
}

.button:focus {
  outline: 3px solid #ffbf47;
}

.button[disabled="disabled"] {
  background: #00823b;
}

.button[disabled="disabled"]:focus {
  outline: none;
}

.button-start,.button-get-started {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 18px;
  line-height: 1.2;
  background-image: image-url("icon-pointer.png");
  background-repeat: no-repeat;
  background-position: 100% 50%;
  padding: .36842em 2.15789em .21053em .84211em;
}

@media (min-width: 641px) {
  .button-start,.button-get-started {
    font-size: 24px;
    line-height: 1.25;
  }
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .button-start,.button-get-started {
    background-image: image-url("icon-pointer-2x.png");
    background-size: 30px 19px;
  }
}

.icon {
  display: inline-block;
  background-position: 0 0;
  background-repeat: no-repeat;
}

.icon-calendar {
  width: 27px;
  height: 27px;
  background-image: image-url("icon-calendar.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-calendar {
    background-image: image-url("icon-calendar-2x.png");
    background-size: 100%;
  }
}

.icon-file-download {
  width: 30px;
  height: 39px;
  background-image: image-url("icon-file-download.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-file-download {
    background-image: image-url("icon-file-download-2x.png");
    background-size: 100%;
  }
}

.icon-important {
  width: 35px;
  height: 35px;
  background-image: image-url("icon-important.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-important {
    background-image: image-url("icon-important-2x.png");
    background-size: 100%;
  }
}

.icon-information {
  width: 27px;
  height: 27px;
  background-image: image-url("icon-information.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-information {
    background-image: image-url("icon-information-2x.png");
    background-size: 100%;
  }
}

.icon-locator {
  width: 26px;
  height: 36px;
  background-image: image-url("icon-locator.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-locator {
    background-image: image-url("icon-locator-2x.png");
    background-size: 100%;
  }
}

.icon-pointer {
  width: 30px;
  height: 19px;
  background-image: image-url("icon-pointer.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-pointer {
    background-image: image-url("icon-pointer-2x.png");
    background-size: 100%;
  }
}

.icon-pointer-black {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-pointer-black.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-pointer-black {
    background-image: image-url("icon-pointer-black-2x.png");
    background-size: 100%;
  }
}

.icon-search {
  width: 30px;
  height: 22px;
  background-image: image-url("icon-search.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-search {
    background-image: image-url("icon-search-2x.png");
    background-size: 100%;
  }
}

.icon-step-1 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-1.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-1 {
    background-image: image-url("icon-steps/icon-step-1-2x.png");
    background-size: 100%;
  }
}

.icon-step-2 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-2.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-2 {
    background-image: image-url("icon-steps/icon-step-2-2x.png");
    background-size: 100%;
  }
}

.icon-step-3 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-3.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-3 {
    background-image: image-url("icon-steps/icon-step-3-2x.png");
    background-size: 100%;
  }
}

.icon-step-4 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-4.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-4 {
    background-image: image-url("icon-steps/icon-step-4-2x.png");
    background-size: 100%;
  }
}

.icon-step-5 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-5.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-5 {
    background-image: image-url("icon-steps/icon-step-5-2x.png");
    background-size: 100%;
  }
}

.icon-step-6 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-6.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-6 {
    background-image: image-url("icon-steps/icon-step-6-2x.png");
    background-size: 100%;
  }
}

.icon-step-7 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-7.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-7 {
    background-image: image-url("icon-steps/icon-step-7-2x.png");
    background-size: 100%;
  }
}

.icon-step-8 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-8.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-8 {
    background-image: image-url("icon-steps/icon-step-8-2x.png");
    background-size: 100%;
  }
}

.icon-step-9 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-9.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-9 {
    background-image: image-url("icon-steps/icon-step-9-2x.png");
    background-size: 100%;
  }
}

.icon-step-10 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-10.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-10 {
    background-image: image-url("icon-steps/icon-step-10-2x.png");
    background-size: 100%;
  }
}

.icon-step-11 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-11.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-11 {
    background-image: image-url("icon-steps/icon-step-11-2x.png");
    background-size: 100%;
  }
}

.icon-step-12 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-12.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-12 {
    background-image: image-url("icon-steps/icon-step-12-2x.png");
    background-size: 100%;
  }
}

.icon-step-13 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-13.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-13 {
    background-image: image-url("icon-steps/icon-step-13-2x.png");
    background-size: 100%;
  }
}

.icon-step-14 {
  width: 23px;
  height: 23px;
  background-image: image-url("icon-steps/icon-step-14.png");
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .icon-step-14 {
    background-image: image-url("icon-steps/icon-step-14-2x.png");
    background-size: 100%;
  }
}

.circle {
  display: inline-block;
  -webkit-border-radius: 50%;
  -moz-border-radius: 50%;
  border-radius: 50%;
  background: #0b0c0c;
  color: #fff;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-size: 12px;
  font-weight: bold;
  text-align: center;
}

.circle-step {
  min-width: 24px;
  min-height: 24px;
  line-height: 24px;
}

.circle-step-large {
  font-size: 19px;
  min-width: 38px;
  min-height: 38px;
  line-height: 38px;
}

ul,ol {
  list-style-type: none;
}

.list {
  padding: 0;
  margin-top: 5px;
  margin-bottom: 20px;
}

.list li {
  margin-bottom: 5px;
}

.list-bullet {
  list-style-type: disc;
  padding-left: 20px;
}

.list-number {
  list-style-type: decimal;
  padding-left: 20px;
}

table {
  border-collapse: collapse;
  border-spacing: 0;
  width: 100%;
}

table th,table td {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
  padding: .63158em 1.05263em .47368em 0;
  text-align: left;
  border-bottom: 1px solid #bfc1c3;
}

@media (min-width: 641px) {
  table th,table td {
    font-size: 19px;
    line-height: 1.31579;
  }
}

table thead th {
  font-weight: 700;
}

table td:last-child,table th:last-child {
  padding-right: 0;
}

table .numeric {
  text-align: right;
}

table td.numeric {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
}

table caption {
  text-align: left;
}

.table-font-xsmall th {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
}

@media (min-width: 641px) {
  .table-font-xsmall th {
    font-size: 16px;
    line-height: 1.25;
  }
}

.table-font-xsmall td {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
}

@media (min-width: 641px) {
  .table-font-xsmall td {
    font-size: 16px;
    line-height: 1.25;
  }
}

.table-font-xsmall th,.table-font-xsmall td {
  padding: .75em 1.25em .5625em 0;
}

details {
  display: block;
  clear: both;
}

details summary {
  display: inline-block;
  color: #005ea5;
  cursor: pointer;
  position: relative;
  margin-bottom: .26316em;
}

details summary:hover {
  color: #2b8cc4;
}

details summary:focus {
  outline: 3px solid #ffbf47;
}

details .summary {
  text-decoration: underline;
}

details .arrow {
  margin-right: .35em;
  font-style: normal;
}

.panel {
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  clear: both;
  border-left-style: solid;
  border-color: #bfc1c3;
  padding: .78947em;
  margin-bottom: .78947em;
}

.panel :first-child {
  margin-top: 0;
}

.panel :only-child,.panel :last-child {
  /*margin-bottom: 0; MB - pri presuvani group/switch do radioButtonu robi zle*/
}

.panel-border-wide {
  border-left-width: 10px;
}

.panel-border-narrow {
  border-left-width: 5px;
}

.form-group .panel-border-narrow {
  float: left;
  width: 100%;
  padding-bottom: 0;
}

.form-group .panel-border-narrow:first-child {
  margin-top: 10px;
}

.form-group .panel-border-narrow:last-child {
  margin-top: 0;
  margin-bottom: 0;
}

.inline .panel-border-narrow,.inline .panel-border-narrow:last-child {
  margin-top: 10px;
  margin-bottom: 0;
}

fieldset {
  width: 100%;
}

legend {
  overflow: hidden;
}

textarea {
  display: block;
}

.form-section,.form-group {
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

.form-section {
  margin-bottom: 30px;
}

@media (min-width: 641px) {
  .form-section {
    margin-bottom: 60px;
  }
}

.form-group {
/*  padding-left : 5px;*/
  margin-bottom: 15px;
}

@media (min-width: 641px) {
  .form-group {
    margin-bottom: 30px !important;
  }
}

.form-group-related {
  margin-bottom: 10px;
}

@media (min-width: 641px) {
  .form-group-related {
    margin-bottom: 20px;
  }
}

.form-group-compound {
  margin-bottom: 10px;
}

.form-label,
.form-label-bold, 
.form-label-bold >p /* mhe - koli staticText komponentu */
{
  display: block;
  color: #0b0c0c;
  padding-bottom: 2px;
}

.form-label {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
}

@media (min-width: 641px) {
  .form-label {
    font-size: 19px;
    line-height: 1.31579;
  }
}

.form-label-bold,
.form-label-bold >p /* mhe - koli staticText komponentu */
{
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
}

@media (min-width: 641px) {
  .form-label-bold,
  .form-label-bold >p /* mhe - koli staticText komponentu */
  {
    font-size: 19px;
    line-height: 1.31579;
  }
}

.form-block {
  float: left;
  clear: left;
  margin-top: -5px;
  margin-bottom: 5px;
}

@media (min-width: 641px) {
  .form-block {
    margin-top: 0;
    margin-bottom: 10px;
  }
}

.form-hint {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
  display: block;
  color: #6f777b;
  font-weight: normal;
  margin-top: -2px;
  padding-bottom: 2px;
}

@media (min-width: 641px) {
  .form-hint {
    font-size: 19px;
    line-height: 1.31579;
  }
}

.form-label .form-hint,.form-label-bold .form-hint {
  margin-top: 0;
  padding-bottom: 0;
}

.form-control {
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
  width: 100%;
  padding: 5px 4px 4px;
  border: 2px solid #0b0c0c;
}

@media (min-width: 641px) {
  .form-control {
    font-size: 19px;
    line-height: 1.31579;
  }
}

@media (min-width: 641px) {
  .form-control {
    width: 100%;
  }
}

input.form-control,textarea.form-control {
  -webkit-appearance: none;
}

textarea.form-control {
  opacity: 1;
  background-image: none;
}

.form-control-3-4 {
  width: 100%;
}

@media (min-width: 641px) {
  .form-control-3-4 {
    width: 75%;
  }
}

.form-control-2-3 {
  width: 100%;
}

@media (min-width: 641px) {
  .form-control-2-3 {
    width: 66.66%;
  }
}

.form-control-1-2 {
  width: 100%;
}

@media (min-width: 641px) {
  .form-control-1-2 {
    width: 50%;
  }
}

.form-control-1-3 {
  width: 100%;
}

@media (min-width: 641px) {
  .form-control-1-3 {
    width: 33.33%;
  }
}

.form-control-1-4 {
  width: 100%;
}

@media (min-width: 641px) {
  .form-control-1-4 {
    width: 25%;
  }
}

.form-control-1-8 {
  width: 100%;
}

@media (min-width: 641px) {
  .form-control-1-8 {
    width: 12.5%;
  }
}

option:active,option:checked,select:focus::-ms-value {
  color: #fff;
  background-color: #005ea5;
}

.multiple-choice {
  display: block;
  float: none;
  clear: left;
  position: relative;
  padding: 0 0 0 38px;
  margin-bottom: 10px;
}

@media (min-width: 641px) {
  .multiple-choice {
    float: left;
  }
}

.multiple-choice input {
  position: absolute;
  cursor: pointer;
  left: 0;
  top: 0;
  width: 38px;
  height: 38px;
  z-index: 1;
  margin: 0;
  zoom: 1;
  filter: alpha(opacity=0);
  opacity: 0;
}

.multiple-choice label {
  cursor: pointer;
  padding: 8px 10px 9px 12px;
  display: block;
  -ms-touch-action: manipulation;
  touch-action: manipulation;
}

@media (min-width: 641px) {
  .multiple-choice label {
    float: left;
    padding-top: 7px;
    padding-bottom: 7px;
  }
}

.multiple-choice [type=radio]+label::before {
  content: "";
  border: 2px solid;
  background: transparent;
  width: 34px;
  height: 34px;
  position: absolute;
  top: 0;
  left: 0;
  -webkit-border-radius: 50%;
  -moz-border-radius: 50%;
  border-radius: 50%;
}

.multiple-choice [type=radio]+label::after {
  content: "";
  border: 10px solid;
  width: 0;
  height: 0;
  position: absolute;
  top: 9px;
  left: 9px;
  -webkit-border-radius: 50%;
  -moz-border-radius: 50%;
  border-radius: 50%;
  zoom: 1;
  filter: alpha(opacity=0);
  opacity: 0;
}

.multiple-choice [type=checkbox]+label::before {
  content: "";
  border: 2px solid;
  background: transparent;
  width: 34px;
  height: 34px;
  position: absolute;
  top: 0;
  left: 0;
}

.multiple-choice [type=checkbox]+label::after {
  content: "";
  border: solid;
  border-width: 0 0 5px 5px;
  background: transparent;
  border-top-color: transparent;
  width: 17px;
  height: 7px;
  position: absolute;
  top: 10px;
  left: 8px;
  -moz-transform: rotate(-45deg);
  -o-transform: rotate(-45deg);
  -webkit-transform: rotate(-45deg);
  -ms-transform: rotate(-45deg);
  transform: rotate(-45deg);
  zoom: 1;
  filter: alpha(opacity=0);
  opacity: 0;
}

.multiple-choice [type=radio]:focus+label::before {
  -webkit-box-shadow: 0 0 0 4px #ffbf47;
  -moz-box-shadow: 0 0 0 4px #ffbf47;
  box-shadow: 0 0 0 4px #ffbf47;
}

.multiple-choice [type=checkbox]:focus+label::before {
  -webkit-box-shadow: 0 0 0 3px #ffbf47;
  -moz-box-shadow: 0 0 0 3px #ffbf47;
  box-shadow: 0 0 0 3px #ffbf47;
}

.multiple-choice input:checked+label::after {
  zoom: 1;
  filter: alpha(opacity=100);
  opacity: 1;
}

.multiple-choice input:disabled {
  cursor: default;
}

.multiple-choice input:disabled+label {
  zoom: 1;
  filter: alpha(opacity=50);
  opacity: .5;
  cursor: default;
}

.multiple-choice:last-child,.multiple-choice:last-of-type {
  margin-bottom: 0;*
}

.inline .multiple-choice {
  clear: none;
}

@media (min-width: 641px) {
  .inline .multiple-choice {
    margin-bottom: 0;
    margin-right: 30px;
  }
}

input::-webkit-outer-spin-button,input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

input[type=number] {
  -moz-appearance: textfield;
}

.form-date .form-group {
  float: left;
  width: 50px;
  margin-right: 20px;
  margin-bottom: 0;
  clear: none;
}

.form-date .form-group label {
  display: block;
  padding-bottom: 2px;
}

.form-date .form-group input {
  width: 100%;
}

.form-date .form-group-year {
  width: 70px;
}

.form-group-error {
  margin-right: 15px;
  border-left: 4px solid #b10e1e;
  padding-left: 10px;
}

@media (min-width: 641px) {
  .form-group-error {
    border-left: 5px solid #b10e1e;
    padding-left: 15px;
  }
}

.form-control-error {
  border: 4px solid #b10e1e;
}

.error-message {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
  color: #b10e1e;
  display: block;
  clear: both;
  margin: 0;
  padding: 2px 0;
}

@media (min-width: 641px) {
  .error-message {
    font-size: 19px;
    line-height: 1.31579;
  }
}

.form-label .error-message,.form-label-bold .error-message {
  padding-top: 4px;
  padding-bottom: 0;
}

.error-summary {
  border: 4px solid #b10e1e;
  margin-top: 15px;
  margin-bottom: 15px;
  padding: 15px 10px;
}

@media (min-width: 641px) {
  .error-summary {
    border: 5px solid #b10e1e;
    margin-top: 30px;
    margin-bottom: 30px;
    padding: 20px 15px 15px;
  }
}

.error-summary:focus {
  outline: 3px solid #ffbf47;
}

.error-summary .error-summary-heading {
  margin-top: 0;
}

.error-summary p {
  margin-bottom: 10px;
}

.error-summary .error-summary-list {
  padding-left: 0;
}

@media (min-width: 641px) {
  .error-summary .error-summary-list li {
    margin-bottom: 5px;
  }
}

.error-summary .error-summary-list a {
  color: #b10e1e;
  font-weight: bold;
  text-decoration: underline;
}

.breadcrumbs {
  padding-top: 0.75em;
  padding-bottom: 0.75em;
}

.breadcrumbs li {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
  float: left;
  background-image: image-url("separator.png");
  background-position: 0% 50%;
  background-repeat: no-repeat;
  list-style: none;
  margin-left: 0.6em;
  margin-bottom: 0.4em;
  padding-left: 0.9em;
}

@media (min-width: 641px) {
  .breadcrumbs li {
    font-size: 16px;
    line-height: 1.25;
  }
}

@media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 20 / 10), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
  .breadcrumbs li {
    background-image: image-url("separator-2x.png");
    background-size: 6px 11px;
  }
}

.breadcrumbs li:first-child {
  background-image: none;
  margin-left: 0;
  padding-left: 0;
}

.breadcrumbs a {
  color: #0b0c0c;
}

.phase-banner {
  padding: 10px 0 8px;
  border-bottom: 1px solid #bfc1c3;
}

@media (min-width: 641px) {
  .phase-banner {
    padding-bottom: 10px;
  }
}

.phase-banner p {
  display: table;
  margin: 0;
  color: #000;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
}

@media (min-width: 641px) {
  .phase-banner p {
    font-size: 16px;
    line-height: 1.25;
  }
}

.phase-banner .phase-tag {
  display: -moz-inline-stack;
  display: inline-block;
  margin: 0 8px 0 0;
  padding: 2px 5px 0;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
  text-transform: uppercase;
  letter-spacing: 1px;
  text-decoration: none;
  color: #fff;
  background-color: #005ea5;
}

@media (min-width: 641px) {
  .phase-banner .phase-tag {
    font-size: 16px;
    line-height: 1.25;
  }
}

.phase-banner span {
  display: table-cell;
  vertical-align: baseline;
}

.phase-banner-alpha,.phase-banner-beta {
  padding: 10px 0 8px;
  border-bottom: 1px solid #bfc1c3;
}

@media (min-width: 641px) {
  .phase-banner-alpha,.phase-banner-beta {
    padding-bottom: 10px;
  }
}

.phase-banner-alpha p,.phase-banner-beta p {
  display: table;
  margin: 0;
  color: #000;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
}

@media (min-width: 641px) {
  .phase-banner-alpha p,.phase-banner-beta p {
    font-size: 16px;
    line-height: 1.25;
  }
}

.phase-banner-alpha .phase-tag,.phase-banner-beta .phase-tag {
  display: -moz-inline-stack;
  display: inline-block;
  margin: 0 8px 0 0;
  padding: 2px 5px 0;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
  text-transform: uppercase;
  letter-spacing: 1px;
  text-decoration: none;
  color: #fff;
  background-color: #005ea5;
}

@media (min-width: 641px) {
  .phase-banner-alpha .phase-tag,.phase-banner-beta .phase-tag {
    font-size: 16px;
    line-height: 1.25;
  }
}

.phase-banner-alpha span,.phase-banner-beta span {
  display: table-cell;
  vertical-align: baseline;
}

.phase-tag {
  display: -moz-inline-stack;
  display: inline-block;
  margin: 0 8px 0 0;
  padding: 2px 5px 0;
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 700;
  text-transform: none;
  font-size: 14px;
  line-height: 1.14286;
  text-transform: uppercase;
  letter-spacing: 1px;
  text-decoration: none;
  color: #fff;
  background-color: #005ea5;
}

@media (min-width: 641px) {
  .phase-tag {
    font-size: 16px;
    line-height: 1.25;
  }
}

.govuk-box-highlight {
  margin: 1em 0;
  padding: 2em 1em;
  color: #fff;
  background: #28a197;
  text-align: center;
}

@-moz-document regexp('.*') {
  details summary:not([tabindex]) {
    display: list-item;
    display: revert;
  }
}

.summary .form-group {
  position: relative;
  border-bottom: 1px solid #bfc1c3;
  width: 100%;
  display: table;
  padding: 0.5em 0 0.1em;
  margin-bottom: 0.1em;
}

.summary .form-group label {
  font-weight: bold;
  margin: .63158em 4em .21053em 0;
  display: table-cell;
  width: 30%;
}

.summary .form-group .value {
  display: table-cell;
  padding-bottom: .47368em;
}

/* MB 9.10.2018
.form-group label {
  font-weight: bold;
}
*/

@media (min-width: 769px) {
  .govuk-check-your-answers {
    display: table;
  }
}

.govuk-check-your-answers>* {
  position: relative;
  border-bottom: 1px solid #bfc1c3;
}

@media (min-width: 769px) {
  .govuk-check-your-answers>* {
    display: table-row;
    border-bottom-width: 0;
  }
}

.govuk-check-your-answers>*>* {
  display: block;
}

@media (min-width: 769px) {
  .govuk-check-your-answers>*>* {
    display: table-cell;
    border-bottom: 1px solid #bfc1c3;
    padding: .63158em 1.05263em .47368em 0;
    margin: 0;
  }
}

@media (min-width: 769px) {
  .govuk-check-your-answers>*:first-child>* {
    padding-top: 0;
  }
}

.govuk-check-your-answers .cya-question {
  font-weight: bold;
  margin: .63158em 4em .21053em 0;
}

.govuk-check-your-answers>*:first-child .cya-question {
  margin-top: 0;
}

@media (min-width: 769px) {
  .govuk-check-your-answers.cya-questions-short,.govuk-check-your-answers.cya-questions-long {
    width: 100%;
  }

  .govuk-check-your-answers.cya-questions-short .cya-question {
    width: 30%;
  }

  .govuk-check-your-answers.cya-questions-long .cya-question {
    width: 50%;
  }
}

.govuk-check-your-answers .cya-answer {
  padding-bottom: .47368em;
}

.govuk-check-your-answers .cya-change {
  text-align: right;
  position: absolute;
  top: 0;
  right: 0;
}

@media (min-width: 769px) {
  .govuk-check-your-answers .cya-change {
    position: static;
    padding-right: 0;
  }
}

.check-your-answers td {
  /* MB 11.10.2018 - pismo je globalne nastavene na konci hlavicky
  font-family: "Source Sans Pro",sans-serif;
  */
  font-weight: 400;
  text-transform: none;
  font-size: 16px;
  line-height: 1.25;
  vertical-align: top;
}

@media (min-width: 641px) {
  .check-your-answers td {
    font-size: 19px;
    line-height: 1.31579;
  }
}

.check-your-answers .change-answer {
  text-align: right;
  font-weight: bold;
  padding-right: 0;
}

button[type="submit"].default-button {
  border: none;
  background: none;
  padding: 0;
  margin: 0;
  outline: none;
}

#deathScreen {
  display: none;
}

.form-horizontal {
  display: flex;
  flex-wrap: wrap;
}

.form-horizontal>* {
  flex-basis: 250px;
}

.summary-section div {
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 7;
    -webkit-box-orient: vertical;
}

@media (min-width: 40.0625em) {
    .govuk-radios--inline:after {
        content: "";
        display: block;
        clear: both;
    }
    .govuk-radios--inline .govuk-radios__item {
        margin-right: 20px;
        float: left;
        clear: none;
    }
}
.govuk-radios--inline.govuk-radios--conditional .govuk-radios__item {
    margin-right: 0;
    float: none;
}
]]></style><!-- gov-extended.css --><style type="text/css"><![CDATA[
  .heading-small, .heading-medium, .heading-large, .heading-xlarge {
  margin-top: 0.25em;
}

p, .grid-row {
  margin: 0px;
}
/* GEL 15.11.2018*/
.wizard-step{
  background : 50% 50% repeat-x #ffffff;
  border : none;
  /*color : #4f4e4e;*/
  margin: 5px;
  grid-column-end: span 12;
}
/* END */
.attr-group {
  background : 50% 50% repeat-x #ffffff;
  border : #d4d4d4 solid 1px;
/*  color : #4f4e4e; */
  border-radius : 3px;
  margin: 5px;
  padding: 0px 15px 0px 15px;
/*  grid-column-end: span 12; */
}

/* GEL 24.10.2018 */
.attr-group-label {
  cursor : pointer;    
  font-weight: bold;
  /*font-size : 0.80em;*/
  color : #0B0C0C;                        /*#4b0082;*/
  border : #BFC1C3 solid 1px;             /*#eae9e8*/
  background-color : #DEE0E2;             /*#F8EFFB*/
  /*border-radius : 3px;*/
  border-radius : 0px;
  padding : 10px;
}
/* END */
.form-label {
  margin-top: 0.25em;
}

/* MB 9.10.2018 
.form-control {
  border-radius : 3px;
  background : #ffffff;
  border : #d3d0ce solid 1px;
  color : #222222;
  padding-left : 4px;
}
*/

button:focus {
    outline: 3px solid #ffbf47;
}
.form-control:focus{
  outline: none;
  border: 2px solid #0b0c0c; /* #d4d4d4; */
  -webkit-box-shadow: 0 0 0 3px #ffbf47;
  -moz-box-shadow: 0 0 0 3px #ffbf47; 
  box-shadow: 0 0 0 3px #ffbf47;
}

input.form-control,textarea.form-control {
  border-radius: 3;
}

.toolbar {
  grid-column: span 12;
  margin: 5px;
  float: left;
  margin-left: 15px;
}

button {
  cursor: pointer;
  display: inline-block;
  margin-right: .5em;
  padding: .526315em .789473em .263157em;
  overflow: visible;
  position: relative;
  text-align: center;
  text-decoration: none !important;
  zoom: 1;
  background-color: #00823b !important;
  color: #fff;
  border: none;
  line-height: 1.4;
  -webkit-font-smoothing: antialiased;
  box-shadow: 0 2px 0 #003618;
  font-size: 1em;
  line-height: 1.25;
}

button:disabled {
  cursor: default;
  opacity: 0.5;
}

 /*END */

/* 1/12 column */
.column-twelfth,.column-one-twelfth {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-twelfth,.column-one-twelfth {
    float: left;
    width: 8.33333%;
  }
}

/* 2/12 column */
.column-two-twelfths {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-two-twelfths {
    float: left;
    width: 16.66667%;
  }
}

/* 5/12 column */
.column-five-twelfths {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-five-twelfths {
    float: left;
    width: 41.66667%;
  }
}

/* 7/12 column */
.column-seven-twelfths {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-seven-twelfths {
    float: left;
    width: 58.33333%;
  }
}

/* 9/12 column */
.column-nine-twelfths {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-nine-twelfths {
    float: left;
    width: 75%;
  }
}

/* 10/12 column */
.column-ten-twelfths {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-ten-twelfths {
    float: left;
    width: 83.33333%;
  }
}

/* 11/12 column */
.column-eleven-twelfths {
  padding: 0 15px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

@media (min-width: 641px) {
  .column-eleven-twelfths {
    float: left;
    width: 91.66667%;
  }
}

/* offset */
@media (min-width: 641px) {
  .column-offset-0 {
    margin-left: 0%;
  }

  .column-offset-1 {
    margin-left: 8.333333%;
  }
  
  .column-offset-2 {
    margin-left: 16.66667%;
  }
  
  .column-offset-3 {
    margin-left: 25%;
  }
  
  .column-offset-4 {
    margin-left: 33.33333%;
  }
  
  .column-offset-5 {
    margin-left: 41.66667%;
  }
  
  .column-offset-6 {
    margin-left: 50%;
  }
  
  .column-offset-7 {
    margin-left: 58.33333%;
  }
  
  .column-offset-8 {
    margin-left: 66.66667%;
  }
  
  .column-offset-9 {
    margin-left: 75%;
  }
  
  .column-offset-10 {
    margin-left: 83.33333%;
  }
  
  .column-offset-11 {
    margin-left: 91.6667%;
  }
  
  .column-offset-12 {
    margin-left: 100%;
  }
}

.clear-both {
  clear: both;
}

.clear-fix:after {
  content: "";
  clear: both;
  display: table;
}

#bloxPageLog {
  clear: both;
}

/* nested group */
.column-full .column-full {
/*  padding: 0px; */
}

.attr-group-content .column-full {
/*  padding: 0px; */
}

.attr-group-content {
  padding-top: 15px;
}

/* group-style-1 - o 15px zo stran uzsia, s 1px okrajom okolo komponentov vnutri */

.group-style-1 {
  background: 50% 50% repeat-x #ffffff;
  border: #d4d4d4 solid 1px;
  border-radius: 3px;
  margin-left: 15px;
  margin-right: 15px;
  padding: 0;
}

/* group-style-1 - prisposobenie sirky na 12 stlpcove zobrazenie */

@media (min-width: 641px) {
  /* 1/12 */
  .group-style-1.column-twelfth,.group-style-1.column-one-twelfth {
    width: calc(8.33333% - 30px);
  }

  /* 2/12 */
  .group-style-1.column-two-twelfths {
    width: calc(16.66667% - 30px);
  }

  /* 3/12 */
  .group-style-1.column-quarter,.group-style-1.column-one-quarter {
    width: calc(25% - 30px);
  }

  /* 4/12 */
  .group-style-1.column-third,.group-style-1.column-one-third {
    width: calc(33.33333% - 30px);
  }

  /* 5/12 */
  .group-style-1.column-five-twelfths {
    width: calc(41.66667% - 30px);
  }

  /* 6/12 */
  .group-style-1.column-half,.group-style-1.column-one-half {
    width: calc(50% - 30px);
  }

  /* 7/12 */
  .group-style-1.column-seven-twelfths {
    width: calc(58.33333% - 30px);
  }

  /* 8/12 */
  .group-style-1.column-two-thirds {
    width: calc(66.66667% - 30px);
  }

  /* 9/12 */
  .group-style-1.column-nine-twelfths {
    width: calc(75% - 30px);
  }

  /* 10/12 */
  .group-style-1.column-ten-twelfths {
    width: calc(83.33333% - 30px);
  }
  
  /* 11/12 */
  .group-style-1.column-eleven-twelfths {
    width: calc(91.66667% - 30px);
  }
  
  /* 12/12 */
  .group-style-1.column-full {
    width: calc(100% - 30px);
  }
}

/* group-style-2 - bez okrajov, 15 px zo stran pre vnutorne komponenty vyriesene vnutornym paddingom - nie je potrebne prepocitavat sirku ako v group-style-1 */
.group-style-2 {
  background: 50% 50% repeat-x #ffffff;
  border: none;
  padding: 0 15px;
  margin: 0;
}

/* group-style-3 - bez okrajov, bez zuzenia pre vnutorne komponenty */
.group-style-3 {
  background: 50% 50% repeat-x #ffffff;
  border: none;
  padding: 0;
  margin: 0;
}

/* group-style-4 - s okrajom, bez zuzenia pre vnutorne komponenty */
.group-style-4 {
  background: 50% 50% repeat-x #ffffff;
  border: #d4d4d4 solid 1px;
  border-radius: 3px;
  padding-left: 0px;
  padding-right: 0px;
  padding-top: 0;
  /*padding: 0;*/
}

/* reduced width in case of an incorrect validation */
@media (min-width: 641px) {
  .column-one-twelfth.error.form-group-error {
    width: calc(8.33333% - 15px);
  }
  .column-two-twelfths.error.form-group-error {
    width: calc(16.66667% - 15px);
  }
  .column-one-quarter.error.form-group-error {
    width: calc(25% - 15px);
  }
  .column-one-third.error.form-group-error {
    width: calc(33.3333% - 15px);
  }
  .column-five-twelfths.error.form-group-error {
    width: calc(41.66667% - 15px);
  }
  .column-one-half.error.form-group-error {
    width: calc(50% - 15px);
  }
  .column-seven-twelfths.error.form-group-error {
    width: calc(58.33333% - 15px);
  }
  .column-two-thirds.error.form-group-error {
    width: calc(66.66667% - 15px);
  }
  .column-nine-twelfths.error.form-group-error {
    width: calc(75% - 15px);
  }
  .column-ten-twelfths.error.form-group-error {
    width: calc(83.33333% - 15px);
  }
  .column-eleven-twelfths.error.form-group-error {
    width: calc(91.66667% - 15px);
  }
}

.hidden-component {
  padding: 0;
}

/* GRID STRUCTURE - NEW - 12.2.2019 */
/*
.form-group {
	padding-right: 15px;
}
*/
/* Grid container */
.grid {
  display: grid;
	grid-template-columns: repeat(12, 1fr);
	grid-template-rows: auto;
	align-items: end;
}

/* grid components */

.grid-column-full, .grid-column-eleven-twelfths, .grid-column-ten-twelfths,.grid-column-nine-twelfths,
.grid-column-two-thirds, .grid-column-seven-twelfths, .grid-column-one-half, .grid-column-five-twelfths,
.grid-column-one-third, .grid-column-one-quarter, .grid-column-two-twelfths, .grid-column-one-twelfth{
  width:100%;
}

.grid-column-full{
  grid-column-end: span 12;
}

.grid-column-eleven-twelfths {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-eleven-twelfths {
	  grid-column-end: span 11;
  }
}

.grid-column-ten-twelfths {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-ten-twelfths {
	  grid-column-end: span 10;
  }
}

.grid-column-nine-twelfths {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-nine-twelfths {
	  grid-column-end: span 9;
  }
}

.grid-column-two-thirds {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-two-thirds {
	  grid-column-end: span 8;
  }
}

.grid-column-seven-twelfths {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-seven-twelfths {
	  grid-column-end: span 7;
  }
}

.grid-column-one-half{
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-one-half {
	  grid-column-end: span 6;
  }
}

.grid-column-five-twelfths {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-five-twelfths {
	  grid-column-end: span 5;
  }
}

.grid-column-one-third {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-one-third {
	  grid-column-end: span 4;
  }
}

.grid-column-one-quarter {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-one-quarter {
	  grid-column-end: span 3;
  }
}

.grid-column-two-twelfths {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-two-twelfths {
	  grid-column-end: span 2;
  }
}

.grid-column-one-twelfth {
  grid-column-end: span 12;
}

@media (min-width: 641px) {
  .grid-column-one-twelfth {
	  grid-column-end: span 1;
  }
}

.new-line {
	clear: both; 
}

.preformatted{
  white-space:pre;
}

/*.checkbox {*/
/*  margin-top: 32px;*/
/*}*/

label {
  word-break: break-word;
}

b {
  font-weight: bold;
}

.heading-xlarge {
  font-size: 52px;
}

@media (min-width: 641px) {
  .heading-xlarge {
    font-size: 52px;
  }
}

.heading-large {
  font-size: 38px;
}

@media (min-width: 641px) {
  .heading-large {
    font-size: 38px;
  }
}

.heading-medium {
  font-size: 26px;
}

@media (min-width: 641px) {
  .heading-medium {
    font-size: 26px;
  }
}

.heading-small {
  font-size: 20px;
}

@media (min-width: 641px) {
  .heading-small {
    font-size: 20px;
  }
}

.success-summary {
    border: 5px solid #005EA5;
}

[data-component='checkbox'][data-no-label]:not(.keep-margin-bottom) {
     margin-bottom: 0;
}
]]></style><!-- dialog.css --><style type="text/css"><![CDATA[
  .dialog {
    background-color: #f0f0f0;
    border-top: 2px solid #666666;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
    bottom: 0;
    padding: 20px;
    position: fixed;
    left: 0;
    height: 0;
    opacity: 0;
    right: 0;
    transition: all 0.2s ease-in-out;
    bottom: -40px;
}

/*
.dialog.show {
    height: 300px;
    opacity: 1;
    bottom: -10px;
}
*/

.dialog.showSaveXml {
    height: 220px;
    opacity: 1;
}

.dialog.showLoadXml {
    height: 195px;
    opacity: 1;
}

.dialog.showLoadXmlWithLocalStorage {
    height: 300px;
    opacity: 1;
}

#pull-from-local-storage-select {
  width: 100%;
  font-size: 1rem;
  padding: 5px 0;
  margin-bottom: 15px;
}

@media (min-width: 641px) {
  #pull-from-local-storage-select {
    width: 300px;
    padding: 5px 0;
    font-size: 1rem;
    margin-right: 30px;
    margin-bottom: 0px;
  }
}

#saveXmlDialog-saveToLocalStorage-versionText {
  width: 100%;
  font-size: 1rem;
  padding: 5px 0;
  margin-bottom: 15px;
}

@media (min-width: 641px) {
  #saveXmlDialog-saveToLocalStorage-versionText {
    width: 300px;
    padding: 5px 0;
    font-size: 1rem;
    margin-right: 30px;
    margin-bottom: 0px;
  }
}

.modal-hld {
  width: 100%; /*100vw;*/
  height: 100vh;
  background: rgba(0,0,0,0.6);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: fixed;
  z-index: 100;
  top: 0;
}

.modal {
  max-width:750px;
  width: 95%; /*750px;*/
  height: 250px;
  background: #f1f1f1;
  border-radius: 5px;
  display: grid;
  grid-template-columns: 1fr 2fr 2fr 1fr;
  grid-template-rows: 1fr 1fr;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-around;
}

.modal input {
  padding: 10px 5px;
  width: 80%;
}

.modal button{
  margin-left:0.5em;
  margin-top:0.5em;
  margin-right:0;
}


]]></style><!-- custom.css --><style type="text/css"><![CDATA[
  .upvs {
  max-width: 927px;
  border: 5px solid black;
  margin: auto;
}
  
.display-none {
  display: none;
}

/* ------ Stylovanie repeat group ----- Start */


/* Odsadenie od buttonu a naslednych opakovani, ak existuje ramcek */
.repeat-item {
  margin-bottom: 10px;
}

.display-repeat-group {
  margin-bottom: 5px;
}

@media (min-width: 641px) {
  .display-repeat-group {
    margin-bottom: 20px;
  }
}

.repeat-item-top-remove-btn {
  display: block;
  margin-top: 5px;
  margin-bottom: 5px
}

.repeat-item-bottom-remove-btn {
  display: block;
  margin-left: 15px;
  margin-top: 5px;
  margin-bottom: 15px;
}

.repeat-item-add-btn {
  margin-left: 15px;
  float: left;
}

/* Roztiahnutie rptGrp, kvoli obalujucemu divu vsetkych itemsov */
div[data-component="repeatGroup"] {
    padding-left: 0;
    padding-right: 0;
}

/* Tabulkovy dizajn repeat group */

@media (min-width: 641px) {
 /*Zrusenie hlaviciek vsetkych opakovani okrem prveho*/
.repeat-group-table-design .repeat-item:not(:first-of-type) .attr-group-label {
	display: none;
}

 /*Zmazanie remove buttonu v hlavicke prveho opakovania*/
.repeat-group-table-design .repeat-item:first-of-type .repeat-item-top-remove-btn {
    display: none;
}

 /*Labely atributov*/
.repeat-group-table-design .repeat-item:not(:first-of-type) .form-label-bold {
    display: none;
}

 /*Spojeny border + vertikalne priblizenie k sebe */
.repeat-group-table-design .repeat-item {
    margin-bottom: -25px;
    background: none;
    float: left;
    /*width: 100%;*/
}

/*Prvy ma vrchny border*/
.repeat-group-table-design .repeat-item:not(:first-of-type) {
    border-top: none;
}

 /*Posledny ma spodny border*/
.repeat-group-table-design .repeat-item:not(:last-of-type) {
    border-bottom: none;
}

 /*----------- Remove buttony ----------*/

 /*Aby boli v tom istom riadku ako obsah*/
.repeat-group-table-design .repeat-item .attr-group-content {
    float: left;
    width: calc(100% - 30px);
}

.repeat-group-table-design .repeat-item:not(:first-of-type) .attr-group-content{
    padding-top: 0
}

 /*Aby mali spravnu velkost a poziciu*/
.repeat-group-table-design .repeat-item-bottom-remove-btn {
    padding: 0px;
    margin-top: 15px;
    margin-left: 0px;
    margin-right: 0px;
    width: 18px;
    height: 18px;
    display: inline;
}

.repeat-group-table-design .repeat-item:first-of-type .repeat-item-bottom-remove-btn {
    margin-top: 57px;
}

 /*Posunutie add buttonu nizsie od posledneho opakovania*/
.repeat-group-table-design .repeat-item:last-of-type {
    padding-bottom: 50px
}

.repeat-group-table-design .repeat-item-add-btn {
    margin-top: -20px;
}

.repeat-group-table-design .repeat-item-add-btn.add-btn-narrow {
    margin-left: 30px;
}

/*Zobrazenie erroru*/
/*.repeat-group-table-design .form-group-error {*/
/*  margin-right: 0px;*/
/*}*/


/*Odsadenie inputu z vrchu na uroven errorovych atributov v riadku*/
.repeat-group-table-design .repeat-item-has-error input:not(.form-control-error),
.repeat-group-table-design .repeat-item-has-error select:not(.form-control-error) {
    margin-top: 30px;
}

/*Odsadenie remove buttonu z vrchu na uroven errorovych atributov v riadku*/
.repeat-group-table-design .repeat-item-has-error .repeat-item-bottom-remove-btn {
    margin-top: 60px;
}

.repeat-group-table-design .repeat-item:first-of-type.repeat-item-has-error .repeat-item-bottom-remove-btn {
    margin-top: 87px;
}

/*Uprava pre display mod*/
.repeat-group-table-design.display-repeat-group .attr-group-content {
    width: 100%;
}

.repeat-group-table-design.display-repeat-group .repeat-item {
    margin-bottom: -24px;
}

/* Tabulkovy dizajn TYP 2 >*/
/* Z komponentov sa vytvori suvisla tabulkova struktura */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item .attr-group-content div[data-component]:first-of-type{
  padding: 0 0 0 15px;
}

.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item .attr-group-content div[data-component]:not(:first-of-type):not(:last-of-type){
  padding: 0;
}

.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item .attr-group-content div[data-component]:last-of-type{
  padding: 0 15px 0 0;
}

/* Zrusenie dvojiteho praveho borderu okrem posledneho stlpca */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item .attr-group-content div[data-component]:not(:last-of-type) input{
  border-right-style: none;
}

/* Vlozenie nazvu komponentov na stred */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .form-label-bold{
  text-align: center;
}

/* Priblizenie opakovani k sebe so zdielanym hornym a dolnym okrajom */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item {
  margin-bottom: -34.5px;
}

/* Posunutie tlacidla pridat nizsie */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item-add-btn {
    margin-top: -15px;
}

/* Kvoli lepsiemu klikaniu */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item:not(:first-of-type) .attr-group-content{
    padding-top: 0
}

/* Kvoli lepsiemu klikaniu */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item:not(:first-of-type) .form-label{
    margin-top: 0
}

/* Vycentrovanie tlacidla zmazat */
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item-bottom-remove-btn{
  margin-top: 10px;
}

/* Odsadenie remove buttonu z vrchu na uroven errorovych atributov v riadku pre typ 2*/
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item-has-error .repeat-item-bottom-remove-btn {
    margin-top: 39px;
}

/* Doladenie selectov v combe a ext enume */
.repeat-group-table-design.rptgrp-tbldsgn-t2 div[data-component='combo'],
.repeat-group-table-design.rptgrp-tbldsgn-t2 div[data-component='externalEnumeration']{
  margin-right: -3px;
}

.repeat-group-table-design.rptgrp-tbldsgn-t2 select {
  height: 38px;
}

/* Nastavenie vysky selectu iba pre IE11 */
_:-ms-fullscreen, :root .repeat-group-table-design.rptgrp-tbldsgn-t2 select {
	height: 37px;
}

/*< Tabulkovy dizajn TYP 2 */

/* Styly errorov v tabulkovych dizajnoch >*/
@media (min-width: 641px) {
  .repeat-group-table-design .column-one-twelfth.error.form-group-error {
    width: 8.33333%;
  }
  .repeat-group-table-design .column-two-twelfths.error.form-group-error {
    width: 16.66667%;
  }
  .repeat-group-table-design .column-column-one-quarter.error.form-group-error {
    width: 25%;
  }
  .repeat-group-table-design .column-one-third.error.form-group-error {
    width: 33.3333%;
  }
  .repeat-group-table-design .column-five-twelfths.error.form-group-error {
    width: 41.66667%;
  }
  .repeat-group-table-design .column-one-half.error.form-group-error {
    width: 50%;
  }
  .repeat-group-table-design .column-seven-twelfths.error.form-group-error {
    width: 58.33333%;
  }
  .repeat-group-table-design .column-two-thirds.error.form-group-error {
    width: 66.66667%;
  }
  .repeat-group-table-design .column-nine-twelfths.error.form-group-error {
    width: 75%;
  }
  .repeat-group-table-design .column-ten-twelfths.error.form-group-error {
    width: 83.33333%;
  }
  .repeat-group-table-design .column-eleven-twelfths.error.form-group-error {
    width: 91.66667%;
  }
}

.repeat-group-table-design .form-group-error {
  margin-right: 0;
  padding-left: 10px;
}

.repeat-group-table-design.rptgrp-tbldsgn-t2 .form-group-error {
  border-left: none;
}

.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item-has-error select:not(.form-control-error),
.repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item-has-error input:not(.form-control-error) {
  height: 40.8px;
}

/* Spresnenie vysky selectu pre IE11 */
_:-ms-fullscreen, :root .repeat-group-table-design.rptgrp-tbldsgn-t2 .repeat-item-has-error select:not(.form-control-error) {
  height: 39px;
}

.repeat-group-table-design.rptgrp-tbldsgn-t2 .error-message {
  text-align: center;
}


/*< Styly errorov v tabulkovych dizajnoch */

/* Fixna sirka */

/*@media (max-width: 1600px) {*/
/*  .min-width-1400 {*/
/*    width: 1400px;*/
/*    background-color: white;*/
/*    padding-bottom: 15px;*/
/*  }*/
/*}*/

.min-width-1400 {
  width: 1400px;
  background-color: white;
  padding-bottom: 15px;
}

@media (min-width: 1600px) {
  .min-width-1400 {
    width: 100%;
  }
}

/* ------ Stylovanie repeat group ----- End */


/* Zobrazenie erroru, unset margin-right kvoli inline komponentom, aby ostali v jednom riadku aj po zobrazeni error hlasky */
.form-group-error {
  /*margin-right: unset;*/
}

/* ------- Styl group ------- Start */
.group-style-5 .repeat-item {
  background: 50% 50% repeat-x #ffffff;
  border: none;
  padding: 0;
  margin: 0;
  margin-left: -15px;
}

.group-style-5 .repeat-item-add-btn {
  margin-left: 0px;
}

/* ------- Styl group ------- End */

/* ------- Styl komponentov v komponente Summary (zhrnutie) ------- Start */

.summary-section  {
  padding-bottom: 15px;
}
.summary-label-first {
  margin-top: 0;
  margin-bottom: 0.1em;
}

.summary-label {
  margin-top: 0.5em;
  margin-bottom: 0.1em;
}

.summary-group-label-first {
  font-size: 20px;
  font-weight: bold;
  margin-top: 0;
}

.summary-group-label {
  font-size: 20px;
  font-weight: bold;
  margin-top: 15px;
}

.summary-nongroup-label {
  font-weight: bold;
}

/* ------- Styl komponentov v komponente Summary (zhrnutie) ------- End */

summary.attr-group-label {
    background-color: transparent;
    border: none;
}



/* https://jump-soft.atlassian.net/browse/E2-1233 */
.govuk-warning-text {
    font-family: Source Sans Pro, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-weight: 400;
    font-size: 16px;
    font-size: 1rem;
    line-height: 1.25;
    color: #0b0c0c;
    position: relative;
    margin-bottom: 20px;
    padding: 10px 0;
}
@media print {
    .govuk-warning-text {
        font-family: sans-serif;
    }
}
@media (min-width: 40.0625em) {
    .govuk-warning-text {
        font-size: 19px;
        font-size: 1.1875rem;
        line-height: 1.31579;
    }
}
@media print {
    .govuk-warning-text {
        font-size: 14pt;
        line-height: 1.15;
        color: #000;
    }
}
@media (min-width: 40.0625em) {
    .govuk-warning-text {
        margin-bottom: 30px;
    }
}
.govuk-warning-text__assistive {
    position: absolute !important;
    width: 1px !important;
    height: 1px !important;
    margin: 0 !important;
    padding: 0 !important;
    overflow: hidden !important;
    clip: rect(0 0 0 0) !important;
    -webkit-clip-path: inset(50%) !important;
    clip-path: inset(50%) !important;
    border: 0 !important;
    white-space: nowrap !important;
}
.govuk-warning-text__icon {
    font-family: Source Sans Pro, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-weight: 700;
    display: inline-block;
    position: absolute;
    top: 50%;
    left: 0;
    min-width: 32px;
    min-height: 29px;
    margin-top: -20px;
    padding-top: 3px;
    border: 3px solid #0b0c0c;
    border-radius: 50%;
    color: #fff;
    background: #0b0c0c;
    font-size: 1.6em;
    line-height: 29px;
    text-align: center;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}
@media print {
    .govuk-warning-text__icon {
        font-family: sans-serif;
    }
}
.govuk-warning-text__text {
    display: block;
    padding-left: 50px;
}

/* https://jump-soft.atlassian.net/browse/E2-1275 */
@media (min-width: 40.0625em) {
    .table-font-50 * {
        font-size: calc(19px - 50%);
        font-size: calc(1.1875rem - 50%);
        line-height: 1.31579;
    }
    
    .table-font-55 * {
        font-size: calc(19px - 45%);
        font-size: calc(1.1875rem - 45%);
        line-height: 1.31579;
    }
    
    .table-font-60 * {
        font-size: calc(19px - 40%);
        font-size: calc(1.1875rem - 40%);
        line-height: 1.31579;
    }
    
    .table-font-65 * {
        font-size: calc(19px - 35%);
        font-size: calc(1.1875rem - 35%);
        line-height: 1.31579;
    }
    
    .table-font-70 * {
        font-size: calc(19px - 30%);
        font-size: calc(1.1875rem - 30%);
        line-height: 1.31579;
    }
    
    .table-font-75 * {
        font-size: calc(19px - 25%);
        font-size: calc(1.1875rem - 25%);
        line-height: 1.31579;
    }

    .table-font-80 * {
        font-size: calc(19px - 20%);
        font-size: calc(1.1875rem - 20%);
        line-height: 1.31579;
    }
    
    .table-font-85 * {
        font-size: calc(19px - 85%);
        font-size: calc(1.1875rem - 85%);
        line-height: 1.31579;
    }
    
    .table-font-90 * {
        font-size: calc(19px - 10%);
        font-size: calc(1.1875rem - 10%);
        line-height: 1.31579;
    }
    
    .table-font-95 * {
        font-size: calc(19px - 5%);
        font-size: calc(1.1875rem - 5%);
        line-height: 1.31579;
    }
}
]]></style><!-- kvoli datetime pickeru --><style type="text/css"><![CDATA[
  /*!
 * Generated using the Bootstrap Customizer (https://getbootstrap.com/docs/3.4/customize/)
 */
/*!
 * Bootstrap v3.4.1 (https://getbootstrap.com/)
 * Copyright 2011-2019 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 */
/*! normalize.css v3.0.3 | MIT License | github.com/necolas/normalize.css */
/*html {*/
/*  font-family: sans-serif;*/
/*  -ms-text-size-adjust: 100%;*/
/*  -webkit-text-size-adjust: 100%;*/
/*}*/
/*body {*/
/*  margin: 0;*/
/*}*/
/*article,*/
/*aside,*/
/*details,*/
/*figcaption,*/
/*figure,*/
/*footer,*/
/*header,*/
/*hgroup,*/
/*main,*/
/*menu,*/
/*nav,*/
/*section,*/
/*summary {*/
/*  display: block;*/
/*}*/
/*audio,*/
/*canvas,*/
/*progress,*/
/*video {*/
/*  display: inline-block;*/
/*  vertical-align: baseline;*/
/*}*/
/*audio:not([controls]) {*/
/*  display: none;*/
/*  height: 0;*/
/*}*/
/*[hidden],*/
/*template {*/
/*  display: none;*/
/*}*/
/*a {*/
/*  background-color: transparent;*/
/*}*/
/*a:active,*/
/*a:hover {*/
/*  outline: 0;*/
/*}*/
/*abbr[title] {*/
/*  border-bottom: none;*/
/*  text-decoration: underline;*/
/*  text-decoration: underline dotted;*/
/*}*/
/*b,*/
/*strong {*/
/*  font-weight: bold;*/
/*}*/
/*dfn {*/
/*  font-style: italic;*/
/*}*/
/*h1 {*/
/*  font-size: 2em;*/
/*  margin: 0.67em 0;*/
/*}*/
/*mark {*/
/*  background: #ff0;*/
/*  color: #000;*/
/*}*/
/*small {*/
/*  font-size: 80%;*/
/*}*/
/*sub,*/
/*sup {*/
/*  font-size: 75%;*/
/*  line-height: 0;*/
/*  position: relative;*/
/*  vertical-align: baseline;*/
/*}*/
/*sup {*/
/*  top: -0.5em;*/
/*}*/
/*sub {*/
/*  bottom: -0.25em;*/
/*}*/
/*img {*/
/*  border: 0;*/
/*}*/
/*svg:not(:root) {*/
/*  overflow: hidden;*/
/*}*/
/*figure {*/
/*  margin: 1em 40px;*/
/*}*/
/*hr {*/
/*  -webkit-box-sizing: content-box;*/
/*  -moz-box-sizing: content-box;*/
/*  box-sizing: content-box;*/
/*  height: 0;*/
/*}*/
/*pre {*/
/*  overflow: auto;*/
/*}*/
/*code,*/
/*kbd,*/
/*pre,*/
/*samp {*/
/*  font-family: monospace, monospace;*/
/*  font-size: 1em;*/
/*}*/
/*button,*/
/*input,*/
/*optgroup,*/
/*select,*/
/*textarea {*/
/*  color: inherit;*/
/*  font: inherit;*/
/*  margin: 0;*/
/*}*/
/*button {*/
/*  overflow: visible;*/
/*}*/
/*button,*/
/*select {*/
/*  text-transform: none;*/
/*}*/
/*button,*/
/*html input[type="button"],*/
/*input[type="reset"],*/
/*input[type="submit"] {*/
/*  -webkit-appearance: button;*/
/*  cursor: pointer;*/
/*}*/
/*button[disabled],*/
/*html input[disabled] {*/
/*  cursor: default;*/
/*}*/
/*button::-moz-focus-inner,*/
/*input::-moz-focus-inner {*/
/*  border: 0;*/
/*  padding: 0;*/
/*}*/
/*input {*/
/*  line-height: normal;*/
/*}*/
/*input[type="checkbox"],*/
/*input[type="radio"] {*/
/*  -webkit-box-sizing: border-box;*/
/*  -moz-box-sizing: border-box;*/
/*  box-sizing: border-box;*/
/*  padding: 0;*/
/*}*/
/*input[type="number"]::-webkit-inner-spin-button,*/
/*input[type="number"]::-webkit-outer-spin-button {*/
/*  height: auto;*/
/*}*/
/*input[type="search"] {*/
/*  -webkit-appearance: textfield;*/
/*  -webkit-box-sizing: content-box;*/
/*  -moz-box-sizing: content-box;*/
/*  box-sizing: content-box;*/
/*}*/
/*input[type="search"]::-webkit-search-cancel-button,*/
/*input[type="search"]::-webkit-search-decoration {*/
/*  -webkit-appearance: none;*/
/*}*/
/*fieldset {*/
/*  border: 1px solid #c0c0c0;*/
/*  margin: 0 2px;*/
/*  padding: 0.35em 0.625em 0.75em;*/
/*}*/
/*legend {*/
/*  border: 0;*/
/*  padding: 0;*/
/*}*/
/*textarea {*/
/*  overflow: auto;*/
/*}*/
/*optgroup {*/
/*  font-weight: bold;*/
/*}*/
/*table {*/
/*  border-collapse: collapse;*/
/*  border-spacing: 0;*/
/*}*/
/*td,*/
/*th {*/
/*  padding: 0;*/
/*}*/
/** {*/
/*  -webkit-box-sizing: border-box;*/
/*  -moz-box-sizing: border-box;*/
/*  box-sizing: border-box;*/
/*}*/
/**:before,*/
/**:after {*/
/*  -webkit-box-sizing: border-box;*/
/*  -moz-box-sizing: border-box;*/
/*  box-sizing: border-box;*/
/*}*/
/*html {*/
/*  font-size: 10px;*/
/*  -webkit-tap-highlight-color: rgba(0, 0, 0, 0);*/
/*}*/
/*body {*/
/*  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;*/
/*  font-size: 14px;*/
/*  line-height: 1.42857143;*/
/*  color: #333333;*/
/*  background-color: #ffffff;*/
/*}*/
/*input,*/
/*button,*/
/*select,*/
/*textarea {*/
/*  font-family: inherit;*/
/*  font-size: inherit;*/
/*  line-height: inherit;*/
/*}*/
/*a {*/
/*  color: #337ab7;*/
/*  text-decoration: none;*/
/*}*/
/*a:hover,*/
/*a:focus {*/
/*  color: #23527c;*/
/*  text-decoration: underline;*/
/*}*/
/*a:focus {*/
/*  outline: 5px auto -webkit-focus-ring-color;*/
/*  outline-offset: -2px;*/
/*}*/
/*figure {*/
/*  margin: 0;*/
/*}*/
/*img {*/
/*  vertical-align: middle;*/
/*}*/
/*.img-responsive {*/
/*  display: block;*/
/*  max-width: 100%;*/
/*  height: auto;*/
/*}*/
/*.img-rounded {*/
/*  border-radius: 6px;*/
/*}*/
/*.img-thumbnail {*/
/*  padding: 4px;*/
/*  line-height: 1.42857143;*/
/*  background-color: #ffffff;*/
/*  border: 1px solid #dddddd;*/
/*  border-radius: 4px;*/
/*  -webkit-transition: all 0.2s ease-in-out;*/
/*  -o-transition: all 0.2s ease-in-out;*/
/*  transition: all 0.2s ease-in-out;*/
/*  display: inline-block;*/
/*  max-width: 100%;*/
/*  height: auto;*/
/*}*/
/*.img-circle {*/
/*  border-radius: 50%;*/
/*}*/
/*hr {*/
/*  margin-top: 20px;*/
/*  margin-bottom: 20px;*/
/*  border: 0;*/
/*  border-top: 1px solid #eeeeee;*/
/*}*/
/*.sr-only {*/
/*  position: absolute;*/
/*  width: 1px;*/
/*  height: 1px;*/
/*  padding: 0;*/
/*  margin: -1px;*/
/*  overflow: hidden;*/
/*  clip: rect(0, 0, 0, 0);*/
/*  border: 0;*/
/*}*/
/*.sr-only-focusable:active,*/
/*.sr-only-focusable:focus {*/
/*  position: static;*/
/*  width: auto;*/
/*  height: auto;*/
/*  margin: 0;*/
/*  overflow: visible;*/
/*  clip: auto;*/
/*}*/
/*[role="button"] {*/
/*  cursor: pointer;*/
/*}*/
.fade {
  opacity: 0;
  -webkit-transition: opacity 0.15s linear;
  -o-transition: opacity 0.15s linear;
  transition: opacity 0.15s linear;
}
.fade.in {
  opacity: 1;
}
.collapse {
  display: none;
}
.collapse.in {
  display: block;
}
tr.collapse.in {
  display: table-row;
}
tbody.collapse.in {
  display: table-row-group;
}
.collapsing {
  position: relative;
  height: 0;
  overflow: hidden;
  -webkit-transition-property: height, visibility;
  -o-transition-property: height, visibility;
  transition-property: height, visibility;
  -webkit-transition-duration: 0.35s;
  -o-transition-duration: 0.35s;
  transition-duration: 0.35s;
  -webkit-transition-timing-function: ease;
  -o-transition-timing-function: ease;
  transition-timing-function: ease;
}
.caret {
  display: inline-block;
  width: 0;
  height: 0;
  margin-left: 2px;
  vertical-align: middle;
  border-top: 4px dashed;
  border-top: 4px solid \9;
  border-right: 4px solid transparent;
  border-left: 4px solid transparent;
}
.dropup,
.dropdown {
  position: relative;
}
.dropdown-toggle:focus {
  outline: 0;
}
.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  z-index: 1000;
  display: none;
  float: left;
  min-width: 160px;
  padding: 5px 0;
  margin: 2px 0 0;
  font-size: 14px;
  text-align: left;
  list-style: none;
  background-color: #ffffff;
  -webkit-background-clip: padding-box;
  background-clip: padding-box;
  border: 1px solid #cccccc;
  border: 1px solid rgba(0, 0, 0, 0.15);
  border-radius: 4px;
  -webkit-box-shadow: 0 6px 12px rgba(0, 0, 0, 0.175);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.175);
}
.dropdown-menu.pull-right {
  right: 0;
  left: auto;
}
.dropdown-menu .divider {
  height: 1px;
  margin: 9px 0;
  overflow: hidden;
  background-color: #e5e5e5;
}
.dropdown-menu >li >a {
  display: block;
  padding: 3px 20px;
  clear: both;
  font-weight: 400;
  line-height: 1.42857143;
  color: #333333;
  white-space: nowrap;
}
.dropdown-menu >li >a:hover,
.dropdown-menu >li >a:focus {
  color: #262626;
  text-decoration: none;
  background-color: #f5f5f5;
}
.dropdown-menu >.active >a,
.dropdown-menu >.active >a:hover,
.dropdown-menu >.active >a:focus {
  color: #ffffff;
  text-decoration: none;
  background-color: #337ab7;
  outline: 0;
}
.dropdown-menu >.disabled >a,
.dropdown-menu >.disabled >a:hover,
.dropdown-menu >.disabled >a:focus {
  color: #777777;
}
.dropdown-menu >.disabled >a:hover,
.dropdown-menu >.disabled >a:focus {
  text-decoration: none;
  cursor: not-allowed;
  background-color: transparent;
  background-image: none;
  filter: progid:DXImageTransform.Microsoft.gradient(enabled = false);
}
.open >.dropdown-menu {
  display: block;
}
.open >a {
  outline: 0;
}
.dropdown-menu-right {
  right: 0;
  left: auto;
}
.dropdown-menu-left {
  right: auto;
  left: 0;
}
.dropdown-header {
  display: block;
  padding: 3px 20px;
  font-size: 12px;
  line-height: 1.42857143;
  color: #777777;
  white-space: nowrap;
}
.dropdown-backdrop {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 990;
}
.pull-right >.dropdown-menu {
  right: 0;
  left: auto;
}
.dropup .caret,
.navbar-fixed-bottom .dropdown .caret {
  content: "";
  border-top: 0;
  border-bottom: 4px dashed;
  border-bottom: 4px solid \9;
}
.dropup .dropdown-menu,
.navbar-fixed-bottom .dropdown .dropdown-menu {
  top: auto;
  bottom: 100%;
  margin-bottom: 2px;
}
@media (min-width: 768px) {
  .navbar-right .dropdown-menu {
    right: 0;
    left: auto;
  }
  .navbar-right .dropdown-menu-left {
    right: auto;
    left: 0;
  }
}
.clearfix:before,
.clearfix:after {
  display: table;
  content: " ";
}
.clearfix:after {
  clear: both;
}
.center-block {
  display: block;
  margin-right: auto;
  margin-left: auto;
}
.pull-right {
  float: right !important;
}
.pull-left {
  float: left !important;
}
.hide {
  display: none !important;
}
.show {
  display: block !important;
}
.invisible {
  visibility: hidden;
}
.text-hide {
  font: 0/0 a;
  color: transparent;
  text-shadow: none;
  background-color: transparent;
  border: 0;
}
.hidden {
  display: none !important;
}
.affix {
  position: fixed;
}
]]></style><!-- bootstrap-datetimepicker.css --><style type="text/css"><![CDATA[
  /*!
 * Datetimepicker for Bootstrap 3
 * version : 4.17.47
 * https://github.com/Eonasdan/bootstrap-datetimepicker/
 */
.bootstrap-datetimepicker-widget {
  list-style: none;
}
.bootstrap-datetimepicker-widget.dropdown-menu {
  display: block;
  margin: 2px 0;
  padding: 4px;
  width: 19em;
}
@media (min-width: 768px) {
  .bootstrap-datetimepicker-widget.dropdown-menu.timepicker-sbs {
    width: 38em;
  }
}
@media (min-width: 992px) {
  .bootstrap-datetimepicker-widget.dropdown-menu.timepicker-sbs {
    width: 38em;
  }
}
@media (min-width: 1200px) {
  .bootstrap-datetimepicker-widget.dropdown-menu.timepicker-sbs {
    width: 38em;
  }
}
.bootstrap-datetimepicker-widget.dropdown-menu:before,
.bootstrap-datetimepicker-widget.dropdown-menu:after {
  content: '';
  display: inline-block;
  position: absolute;
}
.bootstrap-datetimepicker-widget.dropdown-menu.bottom:before {
  border-left: 7px solid transparent;
  border-right: 7px solid transparent;
  border-bottom: 7px solid #ccc;
  border-bottom-color: rgba(0, 0, 0, 0.2);
  top: -7px;
  left: 7px;
}
.bootstrap-datetimepicker-widget.dropdown-menu.bottom:after {
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-bottom: 6px solid white;
  top: -6px;
  left: 8px;
}
.bootstrap-datetimepicker-widget.dropdown-menu.top:before {
  border-left: 7px solid transparent;
  border-right: 7px solid transparent;
  border-top: 7px solid #ccc;
  border-top-color: rgba(0, 0, 0, 0.2);
  bottom: -7px;
  left: 6px;
}
.bootstrap-datetimepicker-widget.dropdown-menu.top:after {
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-top: 6px solid white;
  bottom: -6px;
  left: 7px;
}
.bootstrap-datetimepicker-widget.dropdown-menu.pull-right:before {
  left: auto;
  right: 6px;
}
.bootstrap-datetimepicker-widget.dropdown-menu.pull-right:after {
  left: auto;
  right: 7px;
}
.bootstrap-datetimepicker-widget .list-unstyled {
  margin: 0;
}
.bootstrap-datetimepicker-widget a[data-action] {
  padding: 6px 0;
}
.bootstrap-datetimepicker-widget a[data-action]:active {
  box-shadow: none;
}
.bootstrap-datetimepicker-widget .timepicker-hour,
.bootstrap-datetimepicker-widget .timepicker-minute,
.bootstrap-datetimepicker-widget .timepicker-second {
  width: 54px;
  font-weight: bold;
  font-size: 1.2em;
  margin: 0;
}
.bootstrap-datetimepicker-widget button[data-action] {
  padding: 6px;
}
.bootstrap-datetimepicker-widget .btn[data-action="incrementHours"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Increment Hours";
}
.bootstrap-datetimepicker-widget .btn[data-action="incrementMinutes"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Increment Minutes";
}
.bootstrap-datetimepicker-widget .btn[data-action="decrementHours"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Decrement Hours";
}
.bootstrap-datetimepicker-widget .btn[data-action="decrementMinutes"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Decrement Minutes";
}
.bootstrap-datetimepicker-widget .btn[data-action="showHours"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Show Hours";
}
.bootstrap-datetimepicker-widget .btn[data-action="showMinutes"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Show Minutes";
}
.bootstrap-datetimepicker-widget .btn[data-action="togglePeriod"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Toggle AM/PM";
}
.bootstrap-datetimepicker-widget .btn[data-action="clear"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Clear the picker";
}
.bootstrap-datetimepicker-widget .btn[data-action="today"]::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Set the date to today";
}
.bootstrap-datetimepicker-widget .picker-switch {
  text-align: center;
}
.bootstrap-datetimepicker-widget .picker-switch::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Toggle Date and Time Screens";
}
.bootstrap-datetimepicker-widget .picker-switch td {
  padding: 0;
  margin: 0;
  height: auto;
  width: auto;
  line-height: inherit;
}
.bootstrap-datetimepicker-widget .picker-switch td span {
  line-height: 2.5;
  height: 2.5em;
  width: 100%;
}
.bootstrap-datetimepicker-widget table {
  width: 100%;
  margin: 0;
}
.bootstrap-datetimepicker-widget table td,
.bootstrap-datetimepicker-widget table th {
  text-align: center;
  border-radius: 4px;
}
.bootstrap-datetimepicker-widget table th {
  height: 20px;
  line-height: 20px;
  width: 20px;
}
.bootstrap-datetimepicker-widget table th.picker-switch {
  width: 145px;
}
.bootstrap-datetimepicker-widget table th.disabled,
.bootstrap-datetimepicker-widget table th.disabled:hover {
  background: none;
  color: #777777;
  cursor: not-allowed;
}
.bootstrap-datetimepicker-widget table th.prev::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Previous Month";
}
.bootstrap-datetimepicker-widget table th.next::after {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
  content: "Next Month";
}
.bootstrap-datetimepicker-widget table thead tr:first-child th {
  cursor: pointer;
}
.bootstrap-datetimepicker-widget table thead tr:first-child th:hover {
  background: #eeeeee;
}
.bootstrap-datetimepicker-widget table td {
  height: 54px;
  line-height: 54px;
  width: 54px;
}
.bootstrap-datetimepicker-widget table td.cw {
  font-size: .8em;
  height: 20px;
  line-height: 20px;
  color: #777777;
}
.bootstrap-datetimepicker-widget table td.day {
  height: 20px;
  line-height: 20px;
  width: 20px;
}
.bootstrap-datetimepicker-widget table td.day:hover,
.bootstrap-datetimepicker-widget table td.hour:hover,
.bootstrap-datetimepicker-widget table td.minute:hover,
.bootstrap-datetimepicker-widget table td.second:hover {
  background: #eeeeee;
  cursor: pointer;
}
.bootstrap-datetimepicker-widget table td.old,
.bootstrap-datetimepicker-widget table td.new {
  color: #777777;
}
.bootstrap-datetimepicker-widget table td.today {
  position: relative;
}
.bootstrap-datetimepicker-widget table td.today:before {
  content: '';
  display: inline-block;
  border: solid transparent;
  border-width: 0 0 7px 7px;
  border-bottom-color: #00823b;
  border-top-color: rgba(0, 0, 0, 0.2);
  position: absolute;
  bottom: 4px;
  right: 4px;
}
.bootstrap-datetimepicker-widget table td.active,
.bootstrap-datetimepicker-widget table td.active:hover {
  background-color: #00823b;
  color: #fff;
  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
}
.bootstrap-datetimepicker-widget table td.active.today:before {
  border-bottom-color: #fff;
}
.bootstrap-datetimepicker-widget table td.disabled,
.bootstrap-datetimepicker-widget table td.disabled:hover {
  background: none;
  color: #777777;
  cursor: not-allowed;
}
.bootstrap-datetimepicker-widget table td span {
  display: inline-block;
  width: 54px;
  height: 54px;
  line-height: 54px;
  margin: 2px 1.5px;
  cursor: pointer;
  border-radius: 4px;
}
.bootstrap-datetimepicker-widget table td span:hover {
  background: #eeeeee;
}
.bootstrap-datetimepicker-widget table td span.active {
  background-color: #00823b;
  color: #fff;
  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
}
.bootstrap-datetimepicker-widget table td span.old {
  color: #777777;
}
.bootstrap-datetimepicker-widget table td span.disabled,
.bootstrap-datetimepicker-widget table td span.disabled:hover {
  background: none;
  color: #777777;
  cursor: not-allowed;
}
.bootstrap-datetimepicker-widget.usetwentyfour td.hour {
  height: 27px;
  line-height: 27px;
}
.bootstrap-datetimepicker-widget.wider {
  width: 21em;
}
.bootstrap-datetimepicker-widget .datepicker-decades .decade {
  line-height: 1.8em !important;
}
.input-group.date .input-group-addon {
  cursor: pointer;
}
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
}

.bootstrap-datetimepicker-widget table td a {
    color: #00823b;
}

.bootstrap-datetimepicker-widget .table-condensed>thead>tr>th, 
.bootstrap-datetimepicker-widget .table-condensed>tbody>tr>th, 
.bootstrap-datetimepicker-widget .table-condensed>tfoot>tr>th, 
.bootstrap-datetimepicker-widget .table-condensed>thead>tr>td,
.bootstrap-datetimepicker-widget .table-condensed>tbody>tr>td,
.bootstrap-datetimepicker-widget .table-condensed>tfoot>tr>td {
  padding: 5px;
}
]]></style><style type="text/css">body, input, textarea, .form-label, .heading-small, .heading-medium, .heading-large, .heading-xlarge {
   font-family: 'Arial', sans-serif
}

form {
  margin: 0px auto;
  width: %%globalWidth%%%
}</style></head><body><form><h3 data-uid="a568" style="   text-align: left;" class="form-label label-component   column-full new-line heading-medium">Žiadosť o vyhotovenie kópie listiny uloženej v zbierke listín</h3><div
  name="/e:ApplicationForDocumentCopy/e:MethodOfService"
  class="form-group  column-full new-line"
  data-uid="radioMethodOfService"
  data-component="radioList"
  data-path="/e:ApplicationForDocumentCopy/e:MethodOfService"
  data-dataxmloutputstruct="PGU6Q29kZWxpc3Q+PGU6Q29kZWxpc3RDb2RlPjEwMDA0MDE8L2U6Q29kZWxpc3RDb2RlPjxlOkNvZGVsaXN0SXRlbT48ZTpJdGVtQ29kZT4lJWNsSXRlbUNvZGUlJTwvZTpJdGVtQ29kZT48ZTpJdGVtTmFtZSBMYW5ndWFnZT0nJSVjbEl0ZW1OYW1lTGFuZyUlJz4lJWNsSXRlbU5hbWUlJTwvZTpJdGVtTmFtZT48L2U6Q29kZWxpc3RJdGVtPjwvZTpDb2RlbGlzdD4="
  data-dataxmloutputstructwrapper="PGU6Q29kZWxpc3Q+PGU6Q29kZWxpc3RDb2RlPjEwMDA0MDE8L2U6Q29kZWxpc3RDb2RlPgoJJSVjaGlsZHJlbiUlCjwvZTpDb2RlbGlzdD4="
  data-dataxmloutputstructitem="PGU6Q29kZWxpc3RJdGVtPjxlOkl0ZW1Db2RlPiUlY2xJdGVtQ29kZSUlPC9lOkl0ZW1Db2RlPjxlOkl0ZW1OYW1lIExhbmd1YWdlPSclJWNsSXRlbU5hbWVMYW5nJSUnPiUlY2xJdGVtTmFtZSUlPC9lOkl0ZW1OYW1lPjwvZTpDb2RlbGlzdEl0ZW0+"
  data-dataxmloutputstructvaluepath="/e:Codelist/e:CodelistItem/e:ItemCode"
  
  data-required="True"
  ><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('radioMethodOfService_', position(), '')"/></xsl:when><xsl:otherwise>radioMethodOfService</xsl:otherwise></xsl:choose></xsl:attribute><fieldset><legend><h1 class="heading-medium"><span class="form-label-bold" >V akej podobe žiadate o vyhotovenie kópie listiny uloženej v zbierke listín?</span><span class="form-hint">V prípade výberu listinnej podoby je možné vybrať len jeden subjekt a k nemu jednu listinu.</span><span class="error-message-container"></span></h1></legend><div ><div class="multiple-choice"><input disabled="" type="hidden" value="electronic"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('radioMethodOfService', '_electronic_', position())"/></xsl:when><xsl:otherwise>radioMethodOfService_electronic</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('radioMethodOfService', '_electronic_', position())"/></xsl:when><xsl:otherwise>radioMethodOfService_electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="/e:ApplicationForDocumentCopy/e:MethodOfService[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode = 'electronic'"><xsl:text>&#9899;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#9898;</xsl:text></xsl:otherwise></xsl:choose>v elektronickej podobe</label></div><div class="multiple-choice"><input disabled="" type="hidden" value="print"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('radioMethodOfService', '_print_', position())"/></xsl:when><xsl:otherwise>radioMethodOfService_print</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('radioMethodOfService', '_print_', position())"/></xsl:when><xsl:otherwise>radioMethodOfService_print</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="/e:ApplicationForDocumentCopy/e:MethodOfService[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode = 'print'"><xsl:text>&#9899;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#9898;</xsl:text></xsl:otherwise></xsl:choose>v listinnej podobe</label></div></div></fieldset></div><h4 data-uid="a973" style="  font-weight:bold; text-align: left;" class="form-label label-component   column-full new-line heading-small">Pre ktorý subjekt (zapísanú osobu) žiadate o vyhotovenie kópie listiny uloženej v zbierke listín?</h4><xsl:if test="/e:ApplicationForDocumentCopy/e:MethodOfService[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode='print'"><div class="grid-row  column-full hidden-component" data-component="switch" data-uid="a977"><div class="form-group attr-group-content   column-full grid-row group-style-1" id="groupSubject" data-component="group" data-path="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson" data-group-loaded='true'><div style='' class="form-group  column-full new-line" data-enumid="%%enumid%%" data-component="comboExternal" data-path="./" data-uid="cmbLegalPersonPrint"><label class="form-label" for="cmbLegalPersonPrint"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('cmbLegalPersonPrint_', position(), '')"/></xsl:when><xsl:otherwise>cmbLegalPersonPrint</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Obchodné meno/IČO/Spisová značka</span><span class="form-hint">Uveďte obchodné meno (zadajte obchodné meno, časť obchodného mena, alebo aspoň štyri začiatočné písmená obchodného mena), IČO (v celom znení) alebo spisovú značku v tvare: oddiel/vložka/súd (napr.: Sro/0000/B). Následne vyberte správnu hodnotu z číselníka v tvare napr.: ALFA, s.r.o. (IČO: 10000000, spisová značka: Sro/0000/B).</span></label><select disabled="" class="form-control" name="./"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('cmbLegalPersonPrint_', position(), '')"/></xsl:when><xsl:otherwise>cmbLegalPersonPrint</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="id"><xsl:value-of select="concat('cmbLegalPersonPrint_', position())"/></xsl:attribute><option><xsl:value-of select="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson[not(@*)]/e:Codelist/e:CodelistItem/e:ItemName"/></option></select></div><div class="form-group  column-full new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputSidlo-ListinnaForma_', position(), '')"/></xsl:when><xsl:otherwise>inputSidlo-ListinnaForma</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Sídlo</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputSidlo-ListinnaForma_', position(), '')"/></xsl:when><xsl:otherwise>inputSidlo-ListinnaForma</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson[not(@*)]/e:PersonData/e:PhysicalAddress/e:AddressLine[not(@*)]"/></xsl:attribute></input></div><div class="form-group display-repeat-group  column-full  " data-path="./e:Document" data-uid="rgListDocumentPrint" id="rgListDocumentPrint" data-component="repeatGroup"><xsl:choose><xsl:when test="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson[not(@*)]/e:Document[not(@*)]"><xsl:for-each select="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson[not(@*)]/e:Document[not(@*)]"><div class=" column-full group-style-3 attr-group-content repeat-item grid-row" data-group-id="0"><div class="attr-group-content  grid-row"><div class="form-group  column-full  False" data-component="checkbox" data-path="./e:MakeCopy" data-uid="checkboxVyhotovenieKopieListiny-print" data-required="False" data-no-label="true" data-default-value="False"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Žiadam o vyhotovenie kópie</span></label><div class="multiple-choice checkbox"><input disabled="" type="hidden"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-print</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="./e:MakeCopy[not(@*)] = 'true'"><xsl:text>&#x2611;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#x2610;</xsl:text></xsl:otherwise></xsl:choose>Žiadam o vyhotovenie kópie</label></div></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Kód listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Code[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-full" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Názov listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Name[not(@*)]"/></xsl:attribute></input></div></div></div></xsl:for-each></xsl:when><xsl:otherwise><div class=" column-full group-style-3 attr-group-content repeat-item grid-row" data-group-id="0"><div class="form-group  column-full  False" data-component="checkbox" data-path="./e:MakeCopy" data-uid="checkboxVyhotovenieKopieListiny-print" data-required="False" data-no-label="true" data-default-value="False"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Žiadam o vyhotovenie kópie</span></label><div class="multiple-choice checkbox"><input disabled="" type="hidden"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-print</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="./e:MakeCopy[not(@*)] = 'true'"><xsl:text>&#x2611;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#x2610;</xsl:text></xsl:otherwise></xsl:choose>Žiadam o vyhotovenie kópie</label></div></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Kód listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Code[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-full" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Názov listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-print_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-print</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Name[not(@*)]"/></xsl:attribute></input></div></div></xsl:otherwise></xsl:choose></div></div></div></xsl:if><xsl:if test="/e:ApplicationForDocumentCopy/e:MethodOfService[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode='electronic'"><div class="grid-row  column-full hidden-component" data-component="switch" data-uid="a974"><div class="form-group display-repeat-group  column-full  " data-path="/e:ApplicationForDocumentCopy/e:DocumentsElectronicForm/e:LegalPerson" data-uid="rgListSubjects" id="rgListSubjects" data-component="repeatGroup"><xsl:choose><xsl:when test="/e:ApplicationForDocumentCopy/e:DocumentsElectronicForm/e:LegalPerson[not(@*)]"><xsl:for-each select="/e:ApplicationForDocumentCopy/e:DocumentsElectronicForm/e:LegalPerson[not(@*)]"><div class=" column-full group-style-1 attr-group-content repeat-item grid-row" data-group-id="0"><div class="attr-group-content  grid-row"><div style='' class="form-group  column-full new-line" data-enumid="%%enumid%%" data-component="comboExternal" data-path="./" data-uid="cmbLegalPerson"><label class="form-label" for="cmbLegalPerson"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('cmbLegalPerson_', position(), '')"/></xsl:when><xsl:otherwise>cmbLegalPerson</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Obchodné meno/IČO/Spisová značka</span><span class="form-hint">Uveďte obchodné meno (zadajte obchodné meno, časť obchodného mena, alebo aspoň štyri začiatočné písmená obchodného mena), IČO (v celom znení) alebo spisovú značku v tvare: oddiel/vložka/súd (napr.: Sro/0000/B). Následne vyberte správnu hodnotu z číselníka v tvare napr.: ALFA, s.r.o. (IČO: 10000000, spisová značka: Sro/0000/B).</span></label><select disabled="" class="form-control" name="./"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('cmbLegalPerson_', position(), '')"/></xsl:when><xsl:otherwise>cmbLegalPerson</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="id"><xsl:value-of select="concat('cmbLegalPerson_', position())"/></xsl:attribute><option><xsl:value-of select="./e:Codelist/e:CodelistItem/e:ItemName"/></option></select></div><div class="form-group  column-full new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputSidlo-ElektronickaForma_', position(), '')"/></xsl:when><xsl:otherwise>inputSidlo-ElektronickaForma</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Sídlo</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputSidlo-ElektronickaForma_', position(), '')"/></xsl:when><xsl:otherwise>inputSidlo-ElektronickaForma</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:PersonData/e:PhysicalAddress/e:AddressLine[not(@*)]"/></xsl:attribute></input></div><div class="form-group display-repeat-group  column-full  " data-path="./e:Document" data-uid="rgListDocuments" id="rgListDocuments" data-component="repeatGroup"><xsl:choose><xsl:when test="./e:Document[not(@*)]"><xsl:for-each select="./e:Document[not(@*)]"><div class=" column-full group-style-3 attr-group-content repeat-item grid-row" data-group-id="0"><div class="attr-group-content  grid-row"><div class="form-group  column-full  False" data-component="checkbox" data-path="./e:MakeCopy" data-uid="checkboxVyhotovenieKopieListiny-electronic" data-required="False" data-no-label="true" data-default-value="False"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Žiadam o vyhotovenie kópie</span></label><div class="multiple-choice checkbox"><input disabled="" type="hidden"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="./e:MakeCopy[not(@*)] = 'true'"><xsl:text>&#x2611;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#x2610;</xsl:text></xsl:otherwise></xsl:choose>Žiadam o vyhotovenie kópie</label></div></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Kód listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Code[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-full" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Názov listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Name[not(@*)]"/></xsl:attribute></input></div></div></div></xsl:for-each></xsl:when><xsl:otherwise><div class=" column-full group-style-3 attr-group-content repeat-item grid-row" data-group-id="0"><div class="form-group  column-full  False" data-component="checkbox" data-path="./e:MakeCopy" data-uid="checkboxVyhotovenieKopieListiny-electronic" data-required="False" data-no-label="true" data-default-value="False"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Žiadam o vyhotovenie kópie</span></label><div class="multiple-choice checkbox"><input disabled="" type="hidden"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="./e:MakeCopy[not(@*)] = 'true'"><xsl:text>&#x2611;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#x2610;</xsl:text></xsl:otherwise></xsl:choose>Žiadam o vyhotovenie kópie</label></div></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Kód listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Code[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-full" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Názov listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Name[not(@*)]"/></xsl:attribute></input></div></div></xsl:otherwise></xsl:choose></div></div></div></xsl:for-each></xsl:when><xsl:otherwise><div class=" column-full group-style-1 attr-group-content repeat-item grid-row" data-group-id="0"><div style='' class="form-group  column-full new-line" data-enumid="%%enumid%%" data-component="comboExternal" data-path="./" data-uid="cmbLegalPerson"><label class="form-label" for="cmbLegalPerson"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('cmbLegalPerson_', position(), '')"/></xsl:when><xsl:otherwise>cmbLegalPerson</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Obchodné meno/IČO/Spisová značka</span><span class="form-hint">Uveďte obchodné meno (zadajte obchodné meno, časť obchodného mena, alebo aspoň štyri začiatočné písmená obchodného mena), IČO (v celom znení) alebo spisovú značku v tvare: oddiel/vložka/súd (napr.: Sro/0000/B). Následne vyberte správnu hodnotu z číselníka v tvare napr.: ALFA, s.r.o. (IČO: 10000000, spisová značka: Sro/0000/B).</span></label><select disabled="" class="form-control" name="./"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('cmbLegalPerson_', position(), '')"/></xsl:when><xsl:otherwise>cmbLegalPerson</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="id"><xsl:value-of select="concat('cmbLegalPerson_', position())"/></xsl:attribute><option><xsl:value-of select="./e:Codelist/e:CodelistItem/e:ItemName"/></option></select></div><div class="form-group  column-full new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputSidlo-ElektronickaForma_', position(), '')"/></xsl:when><xsl:otherwise>inputSidlo-ElektronickaForma</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Sídlo</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputSidlo-ElektronickaForma_', position(), '')"/></xsl:when><xsl:otherwise>inputSidlo-ElektronickaForma</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:PersonData/e:PhysicalAddress/e:AddressLine[not(@*)]"/></xsl:attribute></input></div><div class="form-group display-repeat-group  column-full  " data-path="./e:Document" data-uid="rgListDocuments" id="rgListDocuments" data-component="repeatGroup"><xsl:choose><xsl:when test="./e:Document[not(@*)]"><xsl:for-each select="./e:Document[not(@*)]"><div class=" column-full group-style-3 attr-group-content repeat-item grid-row" data-group-id="0"><div class="attr-group-content  grid-row"><div class="form-group  column-full  False" data-component="checkbox" data-path="./e:MakeCopy" data-uid="checkboxVyhotovenieKopieListiny-electronic" data-required="False" data-no-label="true" data-default-value="False"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Žiadam o vyhotovenie kópie</span></label><div class="multiple-choice checkbox"><input disabled="" type="hidden"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="./e:MakeCopy[not(@*)] = 'true'"><xsl:text>&#x2611;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#x2610;</xsl:text></xsl:otherwise></xsl:choose>Žiadam o vyhotovenie kópie</label></div></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Kód listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Code[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-full" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Názov listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Name[not(@*)]"/></xsl:attribute></input></div></div></div></xsl:for-each></xsl:when><xsl:otherwise><div class=" column-full group-style-3 attr-group-content repeat-item grid-row" data-group-id="0"><div class="form-group  column-full  False" data-component="checkbox" data-path="./e:MakeCopy" data-uid="checkboxVyhotovenieKopieListiny-electronic" data-required="False" data-no-label="true" data-default-value="False"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Žiadam o vyhotovenie kópie</span></label><div class="multiple-choice checkbox"><input disabled="" type="hidden"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute></input><label style="margin-left: -50px;"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('checkboxVyhotovenieKopieListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>checkboxVyhotovenieKopieListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:choose><xsl:when test="./e:MakeCopy[not(@*)] = 'true'"><xsl:text>&#x2611;</xsl:text></xsl:when><xsl:otherwise><xsl:text>&#x2610;</xsl:text></xsl:otherwise></xsl:choose>Žiadam o vyhotovenie kópie</label></div></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Kód listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputKodListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputKodListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Code[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-full" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" style='display: none;'>Názov listiny</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputNazovListiny-electronic_', position(), '')"/></xsl:when><xsl:otherwise>inputNazovListiny-electronic</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="./e:Name[not(@*)]"/></xsl:attribute></input></div></div></xsl:otherwise></xsl:choose></div></div></xsl:otherwise></xsl:choose></div></div></xsl:if><xsl:if test="/e:ApplicationForDocumentCopy/e:MethodOfService[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode='print'"><div class="grid-row  column-full hidden-component" data-component="switch" data-uid="a594"><div class="form-group  column-one-half new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a1359_', position(), '')"/></xsl:when><xsl:otherwise>a1359</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Počet kópií</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a1359_', position(), '')"/></xsl:when><xsl:otherwise>a1359</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:choose><xsl:when test="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson/e:NumberOfCopies[not(@*)]"><xsl:value-of select="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson/e:NumberOfCopies[not(@*)]"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute></input></div><div class="form-group  column-one-half new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a582_', position(), '')"/></xsl:when><xsl:otherwise>a582</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Rozsah strán</span><span class="form-hint">Rozsah strán zadajte v tvare napr. 3-10.</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a582_', position(), '')"/></xsl:when><xsl:otherwise>a582</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy/e:DocumentsPrintForm/e:LegalPerson/e:Range[not(@*)]"/></xsl:attribute></input></div></div></xsl:if><div class="form-group  column-one-half new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a621_', position(), '')"/></xsl:when><xsl:otherwise>a621</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Kontaktný email</span><span class="form-hint">Kontaktný email slúži pre posielanie notifikačných správ z OR SR.</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a621_', position(), '')"/></xsl:when><xsl:otherwise>a621</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy/e:Applicant/e:PersonData/e:ElectronicAddress/e:InternetAddress[not(@*)]"/></xsl:attribute></input></div><xsl:if test="/e:ApplicationForDocumentCopy/e:MethodOfService[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode='print'"><div class="grid-row  column-full hidden-component" data-component="switch" data-uid="a622"><h4 data-uid="a661" style="  font-weight:bold; text-align: left;" class="form-label label-component   column-full new-line heading-small">Aká je adresa na doručenie vyhotovenej kópie listiny/listín uložených v zbierke listín?</h4><div class="form-group  column-one-half new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a666_', position(), '')"/></xsl:when><xsl:otherwise>a666</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Meno a priezvisko/Obchodné meno</span><span class="form-hint">V prípade, ak máte viac mien alebo priezvisk, uveďte ich v tomto poli.</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a666_', position(), '')"/></xsl:when><xsl:otherwise>a666</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy/e:ShippingAddress/e:PhysicalAddress/e:DeliveryAddress/e:Recipient[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputCorporateName_', position(), '')"/></xsl:when><xsl:otherwise>inputCorporateName</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >ObchodnéMeno</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputCorporateName_', position(), '')"/></xsl:when><xsl:otherwise>inputCorporateName</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy/e:ShippingAddress/e:PhysicalAddress/e:DeliveryAddress/e:CorporateName[not(@*)]"/></xsl:attribute></input></div><div class="form-group attr-group-content   column-full grid-row group-style-3" id="a671" data-component="group" data-path="/e:ApplicationForDocumentCopy" data-group-loaded='true'><div style='' class="form-group  column-one-half new-line" data-enumid="SUSR_0086" data-component="externalEnumeration" data-path="./e:ShippingAddress/e:PhysicalAddress/e:Country" data-uid="a674"><label class="form-label" for="a674"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a674_', position(), '')"/></xsl:when><xsl:otherwise>a674</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Štát</span></label><select disabled="" class="form-control" name="./e:ShippingAddress/e:PhysicalAddress/e:Country"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a674_', position(), '')"/></xsl:when><xsl:otherwise>a674</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="id"><xsl:value-of select="concat('a674_', position())"/></xsl:attribute><option><xsl:choose><xsl:when test="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:Country[not(@*)]/e:Codelist/e:CodelistItem/e:ItemName"><xsl:value-of select="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:Country[not(@*)]/e:Codelist/e:CodelistItem/e:ItemName"/></xsl:when><xsl:otherwise>703</xsl:otherwise></xsl:choose></option></select></div><xsl:if test="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:Country[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode='703'"><div class="grid-row  column-full hidden-component" data-component="switch" data-uid="a675"><div style='' class="form-group  column-one-half new-line" data-enumid="SUSR_0025" data-component="externalEnumeration" data-path="./e:ShippingAddress/e:PhysicalAddress/e:Municipality" data-uid="a678"><label class="form-label" for="a678"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a678_', position(), '')"/></xsl:when><xsl:otherwise>a678</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Obec</span></label><select disabled="" class="form-control" name="./e:ShippingAddress/e:PhysicalAddress/e:Municipality"><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a678_', position(), '')"/></xsl:when><xsl:otherwise>a678</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="id"><xsl:value-of select="concat('a678_', position())"/></xsl:attribute><option><xsl:value-of select="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:Municipality[not(@*)]/e:Codelist/e:CodelistItem/e:ItemName"/></option></select></div></div></xsl:if><xsl:if test="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:Country[not(@*)]/e:Codelist/e:CodelistItem/e:ItemCode!='703'"><div class="grid-row  column-full hidden-component" data-component="switch" data-uid="a680"><div class="form-group  column-one-half new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a683_', position(), '')"/></xsl:when><xsl:otherwise>a683</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Obec</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a683_', position(), '')"/></xsl:when><xsl:otherwise>a683</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:Municipality/e:NonCodelistData[not(@*)]"/></xsl:attribute></input></div></div></xsl:if><div class="form-group  column-one-half" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a690_', position(), '')"/></xsl:when><xsl:otherwise>a690</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Poštové smerovacie číslo (ZIP)</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a690_', position(), '')"/></xsl:when><xsl:otherwise>a690</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:DeliveryAddress/e:PostalCode[not(@*)]"/></xsl:attribute></input></div><div class="form-group attr-group-content   column-full grid-row group-style-3" id="a684" data-component="group" data-path="." data-group-loaded='true'><div class="form-group  column-one-half new-line" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a685_', position(), '')"/></xsl:when><xsl:otherwise>a685</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Ulica</span><span class="form-hint">Uveďte názov ulice. V prípade, ak v adrese nie je názov ulice, ale iba názov obce, napr. Višňové 55, do tohto poľa vyplnťe názov obce.</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a685_', position(), '')"/></xsl:when><xsl:otherwise>a685</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:StreetName[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-one-third" ><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a686_', position(), '')"/></xsl:when><xsl:otherwise>a686</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >Orientačné/Súpisné číslo</span><span class="form-hint">Zadajte orientačné alebo súpisné číslo.</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('a686_', position(), '')"/></xsl:when><xsl:otherwise>a686</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:BuildingNumber[not(@*)]"/></xsl:attribute></input></div><div class="form-group  column-one-half new-line" style="display:none"><label class="form-label"><xsl:attribute name="for"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputPropertyRegistrationNumber_', position(), '')"/></xsl:when><xsl:otherwise>inputPropertyRegistrationNumber</xsl:otherwise></xsl:choose></xsl:attribute><span class="form-label-bold" >SupisneCislo</span></label><input class="form-control" type="text" disabled=""><xsl:attribute name="id"><xsl:choose><xsl:when test="position() >1"><xsl:value-of select="concat('inputPropertyRegistrationNumber_', position(), '')"/></xsl:when><xsl:otherwise>inputPropertyRegistrationNumber</xsl:otherwise></xsl:choose></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="/e:ApplicationForDocumentCopy[not(@*)]/e:ShippingAddress/e:PhysicalAddress/e:PropertyRegistrationNumber[not(@*)]"/></xsl:attribute></input></div></div></div></div></xsl:if></form></body></html></xsl:template></xsl:stylesheet>