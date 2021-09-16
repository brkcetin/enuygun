*** Settings ***
Library  Selenium2Library
Library  BuiltIn
Library  OperatingSystem
Suite Setup  OPEN PAGE
Suite Teardown  CLOSE PAGE

*** Variables ***
${url}      https://www.enuygun.com/
${browser}  firefox
${from}     İzmir
${to}       İstanbul
${departureHour}  11:15
${returnHour}     15:05

*** Keywords ***
OPEN PAGE
  Open Browser  ${url}  ${browser}
  Set Selenium Speed  0.5
  Maximize Browser Window
  Wait Until Page Contains Element  id:OriginInput

CLOSE PAGE
  Close Browser

FROM - TO INPUTS
  Input Text     id:OriginInput       ${from}
  Sleep  2
  Click Element  //div[text()="ADB"][@class="city_code"]
  Sleep  2
  Input Text     id:DestinationInput  ${to}
  Sleep  2
  Click Element  //div[text()="SAW"][@class="city_code"]

DATE SELECTION
  # Departure date selection
  Click Element  name:DepartureDate
  Sleep  2
  Click Element  //td[@aria-label="Perşembe, 30 Eylül 2021"]
  Sleep  2

  # If checkbox comes selected
  ${status}  Run Keyword And Return Status  Checbox Should Be Selected  id:oneWayCheckbox
  Run Keyword If     ${status}  Unselect Checkbox  id:oneWayCheckbox

  # If date table did't open automatically
  ${status}  Run Keyword And Return Status  Page Should Not Contain Element  //div[contains(@class, "CalendarMonth_caption")]/strong[text()="Eylül 2021"]
  Run Keyword If  ${status}  Click Element  id:ReturnDate
  Sleep  2

  # Try to go to "Aralık" month
  FOR  ${i}  IN RANGE  2
    Click Element  //div[@aria-label="Move forward to switch to the next month."]
    Sleep  2
  END
  # Return date selection
  Click Element  //td[@aria-label="Cuma, 17 Aralık 2021"]
  # Click to "ucuz bilet bul" button
  Click Button   //button[contains(@class, "primary-btn")]

SCROLL DOWN
  Execute Javascript    window.scrollTo(0, document.body.scrollHeight)
  Sleep  2

DEPARTURE HOUR SELECTION
  Click Element  //div[@class="flight-departure-time"][text()="${departureHour}"]
  Sleep  2

RETURN HOUR SELECTION
  Click Element  //div[@class="flight-departure-time"][text()="15:05"]
  Sleep  2

ENTER CONTACT INFORMATIONS
  Wait Until Page Contains  E-posta adresiniz
  Input Text     id:contact_email      cetinn.berkk@gmail.com
  Sleep  2
  Input Text     id:contact_cellphone  549223688
  Sleep  2
  Input Text     id:firstName_0        Berk 
  Sleep  2
  Input Text     id:lastName_0         ÇETİN
  Sleep  2
  Select From List By Value   id:birthDateDay_0    25
  Sleep  2
  Select From List By Value   id:birthDateMonth_0  06
  Sleep  2
  Select From List By Value   id:birthDateYear_0   1997
  Sleep  2
  Input Text     id:publicId_0  40696083994
  Sleep  2
  Select Radio Button  gender_0  M
  Sleep  2
  Execute Javascript    window.scrollTo(0, document.body.scrollHeight)
  Sleep  2
  # Robot can not enter HES code
  Input Text     id:healthCode_0  V2T5317312
  Sleep  2
  Click Element  //button[contains(@class, "js-reservation-btn")]



*** Test Cases ***
TC-1 PLACE SELECTION
  [Documentation]  Enter string and choose the airport
  OPEN PAGE
  FROM - TO INPUTS

TC-2 DATE SELECTION
  [Documentation]  Select flight date
  DATE SELECTION

TC-3 FLIGHT SELECTION
  [Documentation]  Choose a departure and return flight hour
  SCROLL DOWN
  DEPARTURE HOUR SELECTION
  RETURN HOUR SELECTION

TC-4 PASSANGER INFORMATIONS
  [Documentation]  Enter necessary information for ticket
  ENTER CONTACT INFORMATIONS
