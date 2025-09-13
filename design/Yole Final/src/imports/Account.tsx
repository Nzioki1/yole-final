import imgEllipse8 from "figma:asset/2522ce3eff385e93ee8a2b3981b1c52ed3c68ff4.png";
import { imgSegnal, imgWiFi, imgBat, imgSubtract, imgEdit, imgGroup1, imgHome, imgWallet, imgUser, imgUser1, imgUser2 } from "./svg-vaism";

function Segnal() {
  return (
    <div className="absolute h-2.5 left-[299px] top-[18px] w-[15px]" data-name="Segnal">
      <div className="absolute bottom-0 left-0 right-[-20%] top-0">
        <img className="block max-w-none size-full" src={imgSegnal} />
      </div>
    </div>
  );
}

function WiFi() {
  return (
    <div className="absolute h-[11px] left-[321px] top-[17px] w-4" data-name="WiFi">
      <img className="block max-w-none size-full" src={imgWiFi} />
    </div>
  );
}

function Bat() {
  return (
    <div className="absolute h-[11px] left-[343px] top-[17px] w-[23px]" data-name="Bat">
      <img className="block max-w-none size-full" src={imgBat} />
    </div>
  );
}

function StatusBar() {
  return (
    <div className="absolute contents left-6 top-3.5" data-name="StatusBar">
      <div className="absolute font-['Helvetica:Bold',_sans-serif] leading-[0] left-6 not-italic text-[16px] text-nowrap text-white top-3.5 tracking-[0.24px]">
        <p className="leading-[normal] whitespace-pre">08:48</p>
      </div>
      <Segnal />
      <WiFi />
      <Bat />
    </div>
  );
}

function StatusBar1() {
  return (
    <div className="absolute h-[45px] left-0 overflow-clip top-2.5 w-[390px]" data-name="Status Bar">
      <StatusBar />
    </div>
  );
}

function Frame9() {
  return (
    <div className="absolute content-stretch flex gap-[15px] items-center justify-center left-[34px] top-[33px]">
      <div className="font-['Helvetica:Bold',_sans-serif] leading-[normal] not-italic relative shrink-0 text-[0px] text-[rgba(255,255,255,0.87)] text-center text-nowrap tracking-[0.3px] whitespace-pre">
        <p className="mb-1.5 text-[20px]">Total savings</p>
        <p className="font-['Helvetica:Regular',_sans-serif] text-[16px]">You signed up on 12 December 2021</p>
      </div>
    </div>
  );
}

function Frame10() {
  return (
    <div className="absolute content-stretch flex gap-[15px] items-center justify-center left-[41px] top-[233px]">
      <div className="font-['Helvetica:Regular',_sans-serif] leading-[normal] not-italic relative shrink-0 text-[14px] text-[rgba(255,255,255,0.87)] text-center text-nowrap tracking-[0.21px] whitespace-pre">
        <p className="mb-1.5">{`Thanks to your archievements, you can `}</p>
        <p>afford a week’s holiday in Italy.</p>
      </div>
    </div>
  );
}

function Risparmi() {
  return (
    <div className="absolute h-[300px] left-[25px] top-[162px] w-[340px]" data-name="Risparmi">
      <div className="absolute backdrop-blur-[50px] backdrop-filter bg-[#19173d] h-[300px] left-0 rounded-[30px] top-0 w-[340px]">
        <div aria-hidden="true" className="absolute border border-[rgba(255,255,255,0.5)] border-solid inset-0 pointer-events-none rounded-[30px]" />
      </div>
      <Frame9 />
      <Frame10 />
      <div className="absolute font-['Helvetica:Bold',_sans-serif] leading-[0] left-[170.5px] not-italic text-[36px] text-[rgba(255,255,255,0.87)] text-center text-nowrap top-[129px] tracking-[0.54px] translate-x-[-50%]">
        <p className="leading-[normal] whitespace-pre">€1324,76</p>
      </div>
    </div>
  );
}

function Base() {
  return (
    <div className="absolute h-[780px] left-0 top-52 w-[390px]" data-name="Base">
      <div className="absolute h-[780px] left-0 top-0 w-[390px]" data-name="Subtract">
        <img className="block max-w-none size-full" src={imgSubtract} />
      </div>
      <div className="absolute font-['Helvetica:Bold',_sans-serif] leading-[0] left-[117px] not-italic text-[16px] text-[rgba(255,255,255,0.87)] text-nowrap top-[113px] tracking-[0.24px]">
        <p className="leading-[normal] whitespace-pre">Hi, Davide Tacchino</p>
      </div>
      <Risparmi />
    </div>
  );
}

function Edit() {
  return (
    <div className="h-[21px] relative shrink-0 w-[20.739px]" data-name="edit">
      <img className="block max-w-none size-full" src={imgEdit} />
    </div>
  );
}

function Group1() {
  return (
    <div className="h-[21px] relative shrink-0 w-[5px]">
      <img className="block max-w-none size-full" src={imgGroup1} />
    </div>
  );
}

function Frame12() {
  return (
    <div className="content-stretch flex gap-[15px] items-center justify-center relative shrink-0">
      <Edit />
      <Group1 />
    </div>
  );
}

function Frame7() {
  return (
    <div className="absolute content-stretch flex gap-[81px] items-center justify-center left-0 top-0">
      <div className="font-['Helvetica:Bold',_sans-serif] leading-[0] not-italic relative shrink-0 text-[20px] text-[rgba(255,255,255,0.87)] text-nowrap tracking-[0.3px]">
        <p className="leading-[normal] whitespace-pre">Account</p>
      </div>
      <Frame12 />
    </div>
  );
}

function Account() {
  return (
    <div className="absolute h-[23px] left-[154px] top-[74px] w-52" data-name="Account">
      <Frame7 />
      <div className="absolute left-[-34px] size-[150px] top-[60px]">
        <div className="absolute inset-[-2%]">
          <img className="block max-w-none size-full" height="156" src={imgEllipse8} width="156" />
        </div>
      </div>
    </div>
  );
}

function Home() {
  return (
    <div className="absolute inset-[20.83%_85.1%_61.16%_10%]" data-name="Home">
      <div className="absolute inset-[-24.24%_-35.07%_-39.33%_-35.07%]">
        <img className="block max-w-none size-full" src={imgHome} />
      </div>
    </div>
  );
}

function Wallet() {
  return (
    <div className="absolute inset-[20.83%_59.58%_59.32%_33.85%]" data-name="Wallet">
      <img className="block max-w-none size-full" src={imgWallet} />
    </div>
  );
}

function Wallet1() {
  return (
    <div className="absolute contents inset-[20.83%_59.58%_59.32%_33.85%]" data-name="Wallet">
      <Wallet />
    </div>
  );
}

function Insight() {
  return (
    <div className="absolute contents inset-[20.83%_34.8%_61.33%_59.49%]" data-name="Insight">
      <div className="absolute inset-[27.52%_38.91%_61.33%_59.49%] rounded-[1px]">
        <div aria-hidden="true" className="absolute border-2 border-solid border-white inset-0 pointer-events-none rounded-[1px]" />
      </div>
      <div className="absolute inset-[20.83%_36.85%_61.33%_61.55%] rounded-[1px]">
        <div aria-hidden="true" className="absolute border-2 border-solid border-white inset-0 pointer-events-none rounded-[1px]" />
      </div>
      <div className="absolute inset-[24.55%_34.8%_61.33%_63.83%] rounded-[1px]">
        <div aria-hidden="true" className="absolute border-2 border-solid border-white inset-0 pointer-events-none rounded-[1px]" />
      </div>
    </div>
  );
}

function User() {
  return (
    <div className="absolute inset-[20.83%_10.15%_61.33%_84.36%]" data-name="User">
      <div className="absolute inset-[-93.46%]">
        <img className="block max-w-none size-full" src={imgUser} />
      </div>
    </div>
  );
}

function User1() {
  return (
    <div className="absolute inset-[20.83%_10.15%_61.33%_84.36%]" data-name="User">
      <div className="absolute inset-[-140.187%]">
        <img className="block max-w-none size-full" src={imgUser1} />
      </div>
    </div>
  );
}

function User2() {
  return (
    <div className="absolute inset-[20.83%_10.15%_61.33%_84.36%]" data-name="User">
      <img className="block max-w-none size-full" src={imgUser2} />
    </div>
  );
}

function TabBarAccount() {
  return (
    <div className="absolute bg-[#262450] h-[120px] left-0 overflow-clip top-[724px] w-[390px]" data-name="Tab Bar Account">
      <div className="absolute bg-white h-1.5 left-[115px] rounded-[10px] top-[99px] w-40" />
      <Home />
      <Wallet1 />
      <Insight />
      <User />
      <User1 />
      <User2 />
    </div>
  );
}

export default function Account1() {
  return (
    <div className="bg-[#19173d] overflow-clip relative rounded-[50px] size-full" data-name="Account">
      <StatusBar1 />
      <Base />
      <Account />
      <TabBarAccount />
    </div>
  );
}