classdef AppInputs
    properties
        icAdminTeachExpHR
        icAdminTeachRecHR
        icAdminTeachExpLR
        icAdminTeachRecLR
        icStaffExpHR
        icStaffRecHR
        icStaffExpLR
        icStaffRecLR
        icSExpC
        icSRecC
        icSExpNC
        icSRecNC
        soAdminTeachHR
        soAdminTeachLR
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
            obj.icAdminTeachExpHR = .005 * 100;
            obj.icAdminTeachRecHR = .05 * 100;
            obj.icAdminTeachExpLR = .015 * 100;
            obj.icAdminTeachRecLR = .05 * 100;
            obj.icStaffExpHR = .005 * 100;
            obj.icStaffRecHR = .05 * 100;
            obj.icStaffExpLR = .01 * 100;
            obj.icStaffRecLR = .05 * 100;
            obj.icSExpC = .01 * 100;
            obj.icSRecC = .05 * 100;
            obj.icSExpNC = .01 * 100;
            obj.icSRecNC = .05 * 100;
            obj.soAdminTeachHR = .05 * 100;
            obj.soAdminTeachLR = 0.5 * 100;
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

