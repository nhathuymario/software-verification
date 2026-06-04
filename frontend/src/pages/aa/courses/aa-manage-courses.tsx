
import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import "../../../assets/css/pages/lecturer.css";

import { getToken, hasRole } from "../../../services/auth";
import { getAllCourses, deleteCourse, type Course } from "../../../services/course";

type SortKey = "name_asc" | "name_desc";

export default function AaManageCoursesPage() {
    const nav = useNavigate();

    // ✅ đúng cú pháp useState: [value, setValue]
    const [courses, setCourses] = useState<Course[]>([]);
    const [loading, setLoading] = useState(true);
    const [err, setErr] = useState<string | null>(null);

    const [year, setYear] = useState<string>("ALL");
    const [semester, setSemester] = useState<string>("ALL");
    const [q, setQ] = useState("");
    const [sort, setSort] = useState<SortKey>("name_asc");

    const isAA = hasRole("AA") || hasRole("ROLE_AA");

    const fetchCourses = async () => {
        setLoading(true);
        setErr(null);
        try {
            const data = await getAllCourses();
            setCourses(data || []);
        } catch (e: any) {
            const status = e?.response?.status;
            if (status === 401 || status === 403) {
                setErr("Bạn không có quyền hoặc phiên đăng nhập hết hạn.");
            } else {
                setErr(e?.response?.data?.message || e?.message || "Không tải được danh sách môn học test");
            }
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        const token = getToken?.() || localStorage.getItem("token");
        if (!token) {
            setErr("Bạn chưa đăng nhập (thiếu token).");
            setLoading(false);
            return;
        }
        if (!isAA) {
            setErr("Bạn không có quyền truy cập trang này (AA).");
            setLoading(false);
            return;
        }
        fetchCourses();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [isAA]);

    // dropdown options (lấy từ data)
    const yearOptions = useMemo(() => {
        const ys = Array.from(new Set(courses.map((c) => c.academicYear).filter(Boolean))) as string[];
        ys.sort();
        return ys;
    }, [courses]);

    const semesterOptions = useMemo(() => {
        const ss = Array.from(
            new Set(
                courses
                    .filter((c) => year === "ALL" || c.academicYear === year)
                    .map((c) => c.semester)
                    .filter(Boolean)
            )
        ) as string[];

        ss.sort((a, b) => {
            const na = Number(a),
                nb = Number(b);
            const aIsNum = !Number.isNaN(na),
                bIsNum = !Number.isNaN(nb);
            if (aIsNum && bIsNum) return na - nb;
            if (aIsNum) return -1;
            if (bIsNum) return 1;
            return a.localeCompare(b);
        });

        return ss;
    }, [courses, year]);

    useEffect(() => {
        setSemester("ALL");
    }, [year]);

    const view = useMemo(() => {
        const key = q.trim().toLowerCase();
        let list = courses;

        // filter year/semester (client-side)
        if (year !== "ALL") list = list.filter((c) => c.academicYear === year);
        if (semester !== "ALL") list = list.filter((c) => c.semester === semester);

        // search
        if (key) {
            list = list.filter((c) =>
                `${c.code || ""} ${c.name || ""} ${c.department || ""}`.toLowerCase().includes(key)
            );
        }

        // sort
        list = [...list].sort((a, b) => {
            const an = (a.name || a.code || "").toLowerCase();
            const bn = (b.name || b.code || "").toLowerCase();
            return sort === "name_asc" ? an.localeCompare(bn) : bn.localeCompare(an);
        });

        return list;
    }, [courses, q, sort, year, semester]);

    const handleDelete = async (courseId: number) => {
        if (!window.confirm("Xóa môn học này?")) return;
        try {
            await deleteCourse(courseId);
            await fetchCourses();
            alert("Đã xóa môn học.");
        } catch (e: any) {
            alert(e?.response?.data?.message || e?.message || "Xóa thất bại");
        }
    };

    return (
        <div className="lec-page">
            <div className="lec-container">
                <h1 className="lec-title">AA • Quản lý môn học</h1>

                <div className="lec-card">
                    <div className="lec-toolbar">
                        <input
                            className="lec-search"
                            placeholder="Tìm môn học"
                            value={q}
                            onChange={(e) => setQ(e.target.value)}
                        />

                        <select className="lec-select" value={year} onChange={(e) => setYear(e.target.value)}>
                            <option value="ALL">Tất cả năm học</option>
                            {yearOptions.map((y) => (
                                <option key={y} value={y}>
                                    {y}
                                </option>
                            ))}
                        </select>

                        <select
                            className="lec-select"
                            value={semester}
                            onChange={(e) => setSemester(e.target.value)}
                            disabled={year !== "ALL" && semesterOptions.length === 0}
                        >
                            <option value="ALL">Tất cả học kỳ</option>
                            {semesterOptions.map((s) => (
                                <option key={s} value={s}>
                                    HK {s}
                                </option>
                            ))}
                        </select>

                        <select className="lec-select" value={sort} onChange={(e) => setSort(e.target.value as SortKey)}>
                            <option value="name_asc">A → Z</option>
                            <option value="name_desc">Z → A</option>
                        </select>

                        <button className="lec-select" onClick={() => nav("/aa")}>
                            ← Quay lại
                        </button>
                    </div>

                    {loading && <div className="lec-empty">Đang tải.</div>}
                    {err && <div className="lec-empty">❌ {err}</div>}

                    {!loading && !err && (
                        <div className="lec-list">
                            {view.length === 0 ? (
                                <div className="lec-empty">Không có môn học.</div>
                            ) : (
                                view.map((c, idx) => (
                                    <div key={c.id} className="course-row">
                                        <div className={`course-thumb thumb-${idx % 4}`} />

                                        <div className="course-info">
                                            <div className="course-name">
                                                [{c.code || "N/A"}] - {c.name}
                                            </div>

                                            <div className="course-sub">
                                                {c.department || "Chưa có khoa"} · {c.academicYear ?? "-"} · HK {c.semester ?? "-"}
                                            </div>

                                            <div className="course-sub">
                                                Credits: {c.credits ?? "-"} · Lecturer: {c.lecturerUsername ?? "-"}
                                            </div>
                                        </div>

                                        <div style={{ display: "flex", gap: 8, justifyContent: "flex-end" }}>
                                            <button className="lec-select" onClick={() => nav(`/aa/courses/${c.id}/edit`)}>
                                                ✏️ Sửa
                                            </button>

                                            <button className="lec-select" onClick={() => handleDelete(c.id)}>
                                                🗑️ Xóa
                                            </button>
                                        </div>
                                    </div>
                                ))
                            )}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
