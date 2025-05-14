document.addEventListener('DOMContentLoaded', function () {
    // 검색 기능 구현
    const searchInput = document.querySelector('.input-group input');
    const searchButton = document.querySelector('.input-group button');
    const voteTable = document.querySelector('.vote-table');
    const voteRows = document.querySelectorAll('.vote-table tbody tr');
    const emptyState = document.querySelector('.empty-state');
    const tableResponsive = document.querySelector('.table-responsive');
    const pagination = document.querySelector('#pagination');

    // 페이지네이션 렌더링 함수
    function renderPagination() {
        if (!pagination) return;

        // URL에서 현재 페이지 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        const currentPage = parseInt(urlParams.get('page')) || 1;

        // 전체 페이지 수 (서버에서 전달된 값)
        const totalPages = parseInt(document.querySelector('meta[name="totalPages"]')?.content) || 1;

        pagination.innerHTML = '';

        // 이전 페이지 버튼 (항상 표시)
        const prevDisabled = currentPage === 1 ? 'disabled' : '';
        const prevButton = document.createElement('button');
        prevButton.type = 'button';
        prevButton.className = `btn btn-outline-primary page-btn ${prevDisabled}`;
        prevButton.innerHTML = '<i class="bi bi-chevron-left"></i>';

        if (currentPage > 1) {
            prevButton.addEventListener('click', function () {
                window.location.href = `?page=${currentPage - 1}`;
            });
        } else {
            prevButton.disabled = true;
        }

        pagination.appendChild(prevButton);

        // 페이지 번호 버튼
        for (let i = 1; i <= totalPages; i++) {
            const isActive = i === currentPage;
            const btnClass = isActive ? "btn-primary" : "btn-outline-primary";

            const pageButton = document.createElement('button');
            pageButton.type = 'button';
            pageButton.className = `btn ${btnClass} page-btn`;
            pageButton.textContent = i;

            if (!isActive) {
                pageButton.addEventListener('click', function () {
                    window.location.href = `?page=${i}`;
                });
            }

            pagination.appendChild(pageButton);
        }

        // 다음 페이지 버튼 (항상 표시)
        const nextDisabled = currentPage === totalPages ? 'disabled' : '';
        const nextButton = document.createElement('button');
        nextButton.type = 'button';
        nextButton.className = `btn btn-outline-primary page-btn ${nextDisabled}`;
        nextButton.innerHTML = '<i class="bi bi-chevron-right"></i>';

        if (currentPage < totalPages) {
            nextButton.addEventListener('click', function () {
                window.location.href = `?page=${currentPage + 1}`;
            });
        } else {
            nextButton.disabled = true;
        }

        pagination.appendChild(nextButton);
    }

    // 페이지 로드 시 페이지네이션 렌더링
    renderPagination();

    // 검색 함수
    function searchVotes() {
        const searchTerm = searchInput.value.toLowerCase().trim();
        let hasResults = false;

        // 검색어가 없으면 모든 행을 표시
        if (searchTerm === '') {
            voteRows.forEach(row => {
                row.style.display = '';
            });

            // 원래 상태로 복원
            if (voteRows.length > 0) {
                if (tableResponsive) tableResponsive.style.display = '';
                if (pagination) pagination.style.display = '';
                if (emptyState) emptyState.style.display = 'none';
            } else {
                if (tableResponsive) tableResponsive.style.display = 'none';
                if (pagination) pagination.style.display = 'none';
                if (emptyState) emptyState.style.display = '';
            }

            return;
        }

        // 각 행을 검색어와 비교
        voteRows.forEach(row => {
            const title = row.querySelector('.vote-link').textContent.toLowerCase();
            const creator = row.querySelector('td:nth-child(3)').textContent.toLowerCase();

            if (title.includes(searchTerm) || creator.includes(searchTerm)) {
                row.style.display = '';
                hasResults = true;
            } else {
                row.style.display = 'none';
            }
        });

        // 검색 결과가 없을 때 처리
        if (!hasResults && voteRows.length > 0) {
            if (tableResponsive) tableResponsive.style.display = 'none';
            if (pagination) pagination.style.display = 'none';

            // 검색 결과 없음 메시지 표시
            if (emptyState) {
                emptyState.style.display = '';
                const emptyTitle = emptyState.querySelector('h4');
                const emptyText = emptyState.querySelector('p');
                const emptyButton = emptyState.querySelector('a');

                if (emptyTitle) emptyTitle.textContent = '검색 결과가 없습니다';
                if (emptyText) emptyText.textContent = '다른 검색어로 다시 시도해보세요.';
                if (emptyButton) emptyButton.style.display = 'none';
            }
        } else {
            if (tableResponsive) tableResponsive.style.display = '';
            if (pagination) pagination.style.display = hasResults ? '' : 'none';
            if (emptyState) emptyState.style.display = 'none';
        }
    }

    // 검색 버튼 클릭 이벤트
    if (searchButton) {
        searchButton.addEventListener('click', searchVotes);
    }

    // 엔터 키 이벤트
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                searchVotes();
            }
        });
    }

    // 필터 드롭다운 이벤트
    const filterDropdown = document.querySelector('.filter-dropdown');
    if (filterDropdown) {
        filterDropdown.addEventListener('change', function () {
            const selectedOption = this.value;

            // 검색창 초기화
            if (searchInput) searchInput.value = '';

            // 모든 행 표시 초기화
            voteRows.forEach(row => {
                row.style.display = '';
            });

            // 선택된 필터에 따라 행 필터링
            if (selectedOption !== '모든 투표') {
                voteRows.forEach(row => {
                    const statusBadge = row.querySelector('.status-badge');
                    const isActive = statusBadge && statusBadge.classList.contains('status-active');

                    if (selectedOption === '진행 중인 투표' && !isActive) {
                        row.style.display = 'none';
                    } else if (selectedOption === '마감된 투표' && isActive) {
                        row.style.display = 'none';
                    }
                    // '내가 참여한 투표' 필터는 서버 측에서 처리해야 함
                });
            }
        });
    }
});
