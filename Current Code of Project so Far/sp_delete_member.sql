DROP PROCEDURE IF EXISTS sp_delete_member;
DELIMITER //

CREATE PROCEDURE sp_delete_member(IN p_MemberID INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction in case of any error
        ROLLBACK;
        SELECT 'Error! Member not deleted.' AS Result;
    END;

    -- Start the transaction
    START TRANSACTION;

    -- Check if the member exists
    IF EXISTS (SELECT 1 FROM Members WHERE memberID = p_MemberID) THEN
        -- Delete from BookReservations table
        DELETE FROM BookReservations WHERE memberID = p_MemberID;

        -- Delete from Members table
        DELETE FROM Members WHERE memberID = p_MemberID;

        -- Commit the transaction
        COMMIT;

        -- Return success message
        SELECT 'Member deleted' AS Result;
    ELSE
        -- Rollback the transaction if member does not exist
        ROLLBACK;
        SELECT 'Error! Member not deleted.' AS Result;
    END IF;
END //

DELIMITER ;
