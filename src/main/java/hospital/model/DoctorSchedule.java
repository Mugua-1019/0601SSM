package hospital.model;

public class DoctorSchedule {
    private int id;
    private String doctorName;
    private String departmentName;
    private String workDate;
    private String timeSlot;
    private String room;
    private String status;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    public String getWorkDate() { return workDate; }
    public void setWorkDate(String workDate) { this.workDate = workDate; }
    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
    public String getRoom() { return room; }
    public void setRoom(String room) { this.room = room; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
