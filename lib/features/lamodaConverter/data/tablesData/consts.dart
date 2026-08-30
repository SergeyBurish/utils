// --- input file
const String salarySheet = 'Salary';
const int processColumn = 0;
const int loginColumn = 1;
const int startColumn = 3;
const int startRow = 1;
const String fc2Prefix = 'FC2_';


// --- output file
// -- from sheet
// - columns
const int fDate = 0;
const int fShift = 1;
const int fFullName = 2;
const int fLogin = 3;
const int fStatus = 4;
const int fStartDateColumn = 5;
const int fFixed4000Until = 6;
const int fIncreasedRate = 7;
const int fStartWorks = 8;
// offsets after workNames
const int fTotalNumberPeeps = 0;
const int fPeepsWithoutNtt = 1;
const int fAccruedForTraining = 2;
const int fAccruedPerShiftBasedOnNumberOfPeeps = 3;
const int fAccruedForeman = 4;
const int fNumberOfPeopleAdditionally = 5;
const int fAmountOfAdditionalPayment = 6;
const int fPercentageOfProductivity = 7;
const int fBonusPayment = 8;
const int fFixed4000For5Days = 9;
const int fTotalAccrued = 10;
// - rows
const int fHeaderRow = 0;
const int fBidRow = 1;
const int fStartRow = 2;


// -- basic tariffs sheet
// - columns
const int btProcesses = 1;
const int btTtariffForWages = 2;
// - rows
const int btHeaderRow = 0;
const int btStartRow = 1;


// -- employee details sheet
// - columns
const int edLogin = 0;
const int edFullName = 1;
const int edStatus = 2;
const int edStartDateOfWork = 3;
// - rows
const int edHeaderRow = 0;
const int edStartRow = 1;


// --- tariffs file
// - columns
const int trCoeffName = 0;
const int trCoeffVal = 1;
const int trWorks = 0;
const int trStartColumn = 1;
// - rows
const int trCoeffWages = 0;
const int trCoeffWages2months = 1;
const int trDateRow = 2;
const int trHeaderRow = 3;
const int trStartRow = 4;


const String dateFormat = 'dd/mm/yy';

// colors
const String blue01 =   '#E1F8FC';
const String blue02 =   '#C2F2FB';
const String blue03 =   '#006AFF';
const String green01 =  '#BAD8AE';
const String lilac =    '#DCD6EB';
const String pink =     '#FEA7BF';
const String yellow01 = '#F9DF9B';
const String yellow02 = '#FFDB61';
const String yellow03 = '#FFFB00';

const String picksFilePrefix = 'picksLamoda';
const String tariffsFilePrefix = 'tariffsLamoda';