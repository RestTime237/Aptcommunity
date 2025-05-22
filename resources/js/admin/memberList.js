
// 전역 변수로 현재 선택된 회원 ID 저장
let currentUserId = null;

// 회원 상세 보기
window.viewMember = function (userId) {
    currentUserId = userId;

    $.ajax({
        url: `/admin/members/${userId}`,
        method: 'get',
        dataType: 'json',
        success: function (res) {
            $('#detailUsername').text(res.username);
            $('#detailUserId').text(res.userId);
            $('#detailNickname').text(res.nickname);
            $('#detailEmail').text(res.email);
            $('#detailAddress').text(res.roadAddress);
            $('#detailCreatedAt').text(new Date(res.createdAt).toLocaleString());

            new bootstrap.Modal(document.getElementById('memberDetailModal')).show();
        },
        error: function (xhr, status, err) {
            alert('회원 정보를 불러오는데 실패했습니다.');
            console.error('AJAX Error: ', status, err)
        }
    })
}




// 회원 정보 수정
window.loadEditModal = function (userId) {
    currentUserId = userId

    $.ajax({
        url: `/admin/members/${userId}`,
        method: 'GET',
        dataType: 'json',
        success: function (res) {
            $('#editUserId').val(res.userId);
            $('#editUsername').val(res.username);
            $('#editNickname').val(res.nickname);
            $('#editEmail').val(res.email);
            $('#editAddress').val(res.roadAddress);
            $('#editRole').val(res.role);

            currentPassword = res.password;

            new bootstrap.Modal(document.getElementById('memberEditModal')).show();
        },
        error: function (xhr, status, err) {
            alert('회원 정보를 불러오는데 실패했습니다.');
            console.error('AJAX Error:', status, err);
        }
    })
};

// 상세보기에서 수정버튼
window.openEditModal = function () {
    $('#memberDetailModal').modal('hide');
    loadEditModal(currentUserId);
};


// 회원 정보 수정
$('#memberEditForm').on('submit', function (e) {
    e.preventDefault();

    const formData = $(this).serializeArray();
    const member = {};
    formData.forEach(function (field) {
        member[field.name] = field.value;
    });

    member.password = currentPassword;

    $.ajax({
        url: `/admin/members/${currentUserId}`,
        method: 'PUT',
        contentType: 'application/json',
        data: JSON.stringify(member),
        success: function () {
            alert('회원 정보가 수정되었습니다.');
            location.reload();
        },
        error: function (xhr, status, err) {
            alert('회원 정보 수정에 실패했습니다.');
            console.error('AJAX Error:', status, err);
        }
    });
});



// 회원 삭제
let deleteTargetUserId = null;

function deleteMember(userId) {
    deleteTargetUserId = userId;
    new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
}

function confirmDelete() {
    if (!deleteTargetUserId) return;

    $.ajax({
        url: `/admin/members/${deleteTargetUserId}`,
        method: 'DELETE',
        success: function () {
            alert('회원이 삭제되었습니다.');
            location.reload();
        },
        error: function (xhr, status, err) {
            alert('회원 삭제에 실패했습니다.');
            console.error('AJAX Error:', status, err);
        }
    });
}




document.addEventListener('DOMContentLoaded', function () {
    // 검색 기능
    const searchInput = document.getElementById('searchInput');
    const roleFilter = document.getElementById('roleFilter');
    const sortFilter = document.getElementById('sortFilter');
    const tbody = document.querySelector('.admin-table tbody');
    const totalCountSpan = document.getElementById('totalCount');

    function filterTable() {
        const searchTerm = searchInput.value.toLowerCase();
        const roleValue = roleFilter.value;
        const rows = tbody.getElementsByTagName('tr');
        let visibleCount = 0;

        Array.from(rows).forEach(row => {
            const memberInfo = row.querySelector('.member-info').textContent.toLowerCase();
            const userId = row.cells[1].textContent.toLowerCase();
            const role = row.querySelector('.badge-role').textContent;

            const matchesSearch = memberInfo.includes(searchTerm) ||
                userId.includes(searchTerm);

            const matchesRole = roleValue === 'all' ||
                (roleValue === 'admin' && role === '관리자') ||
                (roleValue === 'regular' && role === '일반');

            if (matchesSearch && matchesRole) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        totalCountSpan.textContent = visibleCount;
    }

    // 이벤트 리스너 등록
    searchInput.addEventListener('input', filterTable);
    roleFilter.addEventListener('change', filterTable);
    sortFilter.addEventListener('change', function () {
        const rows = Array.from(tbody.getElementsByTagName('tr'));
        const sortValue = this.value;

        rows.sort((a, b) => {
            if (sortValue === 'newest' || sortValue === 'oldest') {
                const dateA = new Date(a.cells[5].textContent);
                const dateB = new Date(b.cells[5].textContent);
                return sortValue === 'newest' ? dateB - dateA : dateA - dateB;
            } else if (sortValue === 'name') {
                const nameA = a.querySelector('.member-name').textContent;
                const nameB = b.querySelector('.member-name').textContent;
                return nameA.localeCompare(nameB, 'ko');
            }
        });

        rows.forEach(row => tbody.appendChild(row));
    });


});