classdef AppInputs
    properties
        icATExpHR
        icATRecHR
        icATExpLR
        icATRecLR
        icStaffExpHR
        icStaffRecHR
        icStaffExpLR
        icStaffRecLR
        icSExpC
        icSRecC
        icSExpNC
        icSRecNC
        soATHR
        soATLR
        soStaffHR
        soStaffLR
        soSC
        soSNC
        propNC
        scaleTracking
        incAsymp
        
    end
    
    methods
        function obj = AppInputs()
            obj.icATExpHR = .005 * 100;
            obj.icATRecHR = .05 * 100;
            obj.icATExpLR = .015 * 100;
            obj.icATRecLR = .05 * 100;
            obj.icStaffExpHR = .005 * 100;
            obj.icStaffRecHR = .05 * 100;
            obj.icStaffExpLR = .01 * 100;
            obj.icStaffRecLR = .05 * 100;
            obj.icSExpC = .01 * 100;
            obj.icSRecC = .05 * 100;
            obj.icSExpNC = .01 * 100;
            obj.icSRecNC = .05 * 100;
            obj.soATHR = .05 * 100;
            obj.soATLR = 0.2 * 100;
            obj.soStaffHR = 1;
            obj.soStaffLR = 1;
            obj.soSC = 1;
            obj.soSNC = 1;
            obj.propNC = 1;
            obj.scaleTracking = 1;
            obj.incAsymp = 1;
        end
    end
    
end

