function inputs = inputPreset(idx)
inputs = AppInputs();
switch(idx)
    case 1
        inputs.icATExpHR = 0;
        inputs.icATRecHR = .01* 100;
        inputs.icATExpLR = .002* 100;
        inputs.icATRecLR = .05* 100;
        inputs.icStaffExpHR = 0;
        inputs.icStaffRecHR = .01* 100;
        inputs.icStaffExpLR = .002* 100;
        inputs.icStaffRecLR = .05* 100;
        inputs.icSExpC = .015* 100;
        inputs.icSRecC = .08* 100;
        inputs.icSExpNC = .015* 100;
        inputs.icSRecNC = .08* 100;
        inputs.soATHR = 0;
        inputs.soATLR = 1/7;
        inputs.soStaffHR = 0;
        inputs.soStaffLR = 1/7;
        inputs.soSC = 1/7;
        inputs.soSNC = 3/7;
        inputs.propNC = 0.25* 100;
        inputs.scaleTracking = .8 * 100;
        inputs.incAsymp = .75* 100;
        
    case 2
        inputs.icATExpHR = 0;
        inputs.icATRecHR = .01* 100;
        inputs.icATExpLR = .002* 100;
        inputs.icATRecLR = .05* 100;
        inputs.icStaffExpHR = 0;
        inputs.icStaffRecHR = .01* 100;
        inputs.icStaffExpLR = .002* 100;
        inputs.icStaffRecLR = .05* 100;
        inputs.icSExpC = .015* 100;
        inputs.icSRecC = .08* 100;
        inputs.icSExpNC = .015* 100;
        inputs.icSRecNC = .08* 100;
        inputs.soATHR = 0;
        inputs.soATLR = 1/7;
        inputs.soStaffHR = 0;
        inputs.soStaffLR = 1/7;
        inputs.soSC = 3/7;
        inputs.soSNC = 10/7;
        inputs.propNC = 0.75* 100;
        inputs.scaleTracking = .8* 100;
        inputs.incAsymp = .75* 100;
        
    case 3
        inputs.icATExpHR = 0.015* 100;
        inputs.icATRecHR = .05* 100;
        inputs.icATExpLR = .015* 100;
        inputs.icATRecLR = .05* 100;
        inputs.icStaffExpHR = 0.015* 100;
        inputs.icStaffRecHR = .05* 100;
        inputs.icStaffExpLR = .015* 100;
        inputs.icStaffRecLR = .05* 100;
        inputs.icSExpC = .015* 100;
        inputs.icSRecC = .05* 100;
        inputs.icSExpNC = .015* 100;
        inputs.icSRecNC = .05* 100;
        inputs.soATHR = 0.12;
        inputs.soATLR = 1;
        inputs.soStaffHR = 0.12;
        inputs.soStaffLR = 1;
        inputs.soSC = 1;
        inputs.soSNC = 2;
        inputs.propNC = 0.5* 100;
        inputs.scaleTracking = .5* 100;
        inputs.incAsymp = .75* 100;
        
end
end
