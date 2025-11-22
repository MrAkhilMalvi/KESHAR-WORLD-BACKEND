import jsonData from "./errorCode.json" with { type: "json" };
import _ from "lodash";

function errorHandler(code, message, constraint) {
    let errorObj = {};
    let msg = "";

    switch (code) {
        case "42601":
            return {
                success: false,
                code,
                devMsg: "SQL Syntax Error",
                message: "Something went wrong. Please try again"
            };
        case "42703":
            return {
                success: false,
                code,
                devMsg: "Unknown Column",
                message: "Something went wrong. Please try again"
            };
        case "23503":
            msg =
                constraint === "fk_test_section_test_id"
                    ? "To delete this test, delete the sections first."
                    : "This module is used by other modules.";
            return {
                success: false,
                code,
                devMsg: "Foreign key constraint",
                message: msg
            };
        case "23505":
            msg =
                constraint === "uni_users_mobile_no"
                    ? "Mobile number already registered."
                    : "Duplicate entry for unique constraint.";
            return {
                success: false,
                code,
                devMsg: "Duplicate Entry",
                message: msg
            };
        case "23514":
            msg =
                constraint === "chk_test_session_time_from_time_to"
                    ? "Exam schedule from_time must be smaller than to_time."
                    : "Check constraint failed";
            return {
                success: false,
                code,
                devMsg: "Check constraint failed",
                message: msg
            };
        case "22P02":
            return {
                success: false,
                code,
                devMsg: "Invalid Text Representation",
                message: "Data is not proper."
            };
        case "08P01":
            return {
                success: false,
                code,
                devMsg: "Protocol Violation",
                message: "Data is not available."
            };
        case "42883":
            return {
                success: false,
                code,
                devMsg: "Undefined Function",
                message: "Function is undefined."
            };
        case "11111":
        case "22222":
            return {
                success: false,
                code,
                message
            };

        default:
            const jsonErr = _.find(jsonData, { code });

            const cleanMsg = typeof message === "string"
                ? message.replace(/%/g, "")
                : null;

            if (cleanMsg) {
                return { success: false, message: cleanMsg };
            }

            if (jsonErr?.message) {
                return { success: false, message: jsonErr.message };
            }

            return {
                success: false,
                devMsg: "Error",
                message: "Error occurred. Please contact administrator"
            };
    }
}

export { errorHandler };   // ✅ NAMED EXPORT
