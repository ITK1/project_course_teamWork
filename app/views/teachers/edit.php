<div style="text-align: center; margin-bottom: 2rem;">
    <span style="font-size: 4rem; display: block; margin-bottom: 1rem;">✏️</span>
    <h2 style="margin: 0;">Sửa thông tin giáo viên</h2>
</div>

<form method="POST" action="/teachers/edit/<?php echo $teacher['id']; ?>">
    <div class="form-group">
        <label for="name">👤 Họ tên:</label>
        <input type="text" id="name" name="name" value="<?php echo htmlspecialchars($teacher['name']); ?>" required>
    </div>
    <div class="form-group">
        <label for="email">📧 Email:</label>
        <input type="email" id="email" name="email" value="<?php echo htmlspecialchars($teacher['email']); ?>" required>
    </div>
    <div class="form-group">
        <label for="specialization">🎯 Chuyên môn:</label>
        <input type="text" id="specialization" name="specialization" value="<?php echo htmlspecialchars($teacher['specialization']); ?>" required>
    </div>
    <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 2rem;">
        <button type="submit" class="btn btn-primary">💾 Cập nhật</button>
        <a href="/teachers" class="btn btn-secondary">❌ Hủy</a>
    </div>
</form>

